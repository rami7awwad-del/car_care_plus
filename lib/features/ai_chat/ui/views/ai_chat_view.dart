import 'package:car_care_plus/Localization/l10n/app_localization.dart';
import 'package:car_care_plus/core/resources/app_color.dart';
import 'package:car_care_plus/core/resources/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/ai_chat_message.dart';
import '../../data/models/ai_diagnosis_model.dart';
import '../../logic/ai_chat_cubit.dart';
import '../../logic/ai_chat_state.dart';
import '../widgets/ai_chat_input_field.dart';
import '../widgets/ai_chat_welcome_card.dart';
import '../widgets/ai_diagnosis_card.dart';
import '../widgets/ai_message_bubble.dart';

/// شاشة المساعد الذكي: يصف المستخدم مشكلته، يجيب على ستة أسئلة قصيرة،
/// ثم يعرض التشخيص مع الخدمة المقترحة
class AiChatView extends StatefulWidget {
  /// يُمرَّر عند فتح المحادثة من طلب صيانة قائم: يحسّن دقة التشخيص لأن
  /// السيرفر يقرأ منه نوع السيارة وماركتها ووقودها، وهو شرط إضافة الخدمة
  final int? orderId;

  const AiChatView({super.key, this.orderId});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  final ScrollController _scrollController = ScrollController();

  /// يمنع تكرار إشعار نجاح إضافة الخدمة مع كل إعادة بناء لاحقة
  bool _serviceAppliedNotified = false;

  @override
  void initState() {
    super.initState();
    // لا تُفقد محادثة جارية إن كان المستخدم قد غادر الشاشة وعاد إليها
    context.read<AiChatCubit>().openChat(orderId: widget.orderId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: _buildAppBar(context, l10n),
      body: BlocConsumer<AiChatCubit, AiChatState>(
        listener: (context, state) {
          _scrollToBottom();
          if (!state.isServiceApplied) _serviceAppliedNotified = false;
          if (state.isServiceApplied && !_serviceAppliedNotified) {
            _serviceAppliedNotified = true;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.successColor,
                  content: Text(
                    l10n.aiServiceAppliedSuccess,
                    style: TextStyles.Size15.withColor(AppColors.surfaceWhite),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AiChatCubit>();

          return Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // رسالة الترحيب تُبنى من الترجمة بدل تخزينها كرسالة، حتى
                    // تتبع اللغة إذا بدّلها المستخدم
                    if (state.messages.isEmpty) const AiChatWelcomeCard(),

                    ...state.messages.map(
                      (message) => _buildMessage(context, state, cubit, message),
                    ),

                    // نداء التشخيص الأخير قد يستغرق حتى دقيقة كاملة
                    if (state.isBusy)
                      AiTypingIndicator(
                        label: state.answers.length >= 6
                            ? l10n.aiChatAnalyzing
                            : l10n.aiChatPreparing,
                      ),

                    // يظهر أيضاً لأخطاء إضافة الخدمة التي تقع بعد انتهاء
                    // المحادثة، حيث تبقى الحالة `finished`
                    if (state.failure != null)
                      _ErrorBanner(
                        message: _failureMessage(l10n, state.failure!),
                        // لا إعادة محاولة تلقائية: الطلب الفاشل قد يكون استهلك
                        // نداء نموذج لغوي، فالقرار للمستخدم
                        onRetry: _canRetry(state) ? cubit.retry : null,
                      ),

                    if (state.status == AiChatStatus.finished)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: cubit.reset,
                            icon: Icon(
                              Icons.refresh_rounded,
                              size: 18.r,
                              color: AppColors.primaryBlue,
                            ),
                            label: Text(
                              l10n.aiChatStartNewConversation,
                              style: TextStyles.Size15.withColor(
                                AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              AiChatInputField(
                hint: _hintFor(l10n, state),
                // بعد فشل طلب داخل محادثة جارية يكون المسار الصحيح هو إعادة
                // المحاولة، لا كتابة نص جديد يمحو الإجابات المجمّعة
                enabled: !state.isBusy &&
                    state.status != AiChatStatus.finished &&
                    !_isBlockedByError(state),
                onSend: (text) {
                  if (state.status == AiChatStatus.awaitingAnswer) {
                    cubit.submitAnswer(text);
                  } else {
                    cubit.startConversation(text);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context,
    AiChatState state,
    AiChatCubit cubit,
    AiChatMessage message,
  ) {
    if (message.isDiagnosis) {
      return AiDiagnosisCard(
        diagnosis: message.diagnosis!,
        canApplyService: state.canApplyService,
        isApplying: state.isApplyingService,
        isApplied: state.isServiceApplied,
        onApplyService: cubit.applyRecommendedService,
      );
    }
    return AiMessageBubble(message: message);
  }

  bool _isBlockedByError(AiChatState state) =>
      state.status == AiChatStatus.error && state.problem.isNotEmpty;

  /// حلقة الأسئلة المكسورة لا تُصلحها إعادة المحاولة — المخرج منها محادثة جديدة
  bool _canRetry(AiChatState state) =>
      _isBlockedByError(state) &&
      state.failure?.kind != AiFailureKind.conversationLoop;

  /// رسالة السيرفر أدقّ من أي نص عام، فنعرضها حين تصل ونلجأ للترجمة عند غيابها
  String _failureMessage(AppLocalizations l10n, AiChatFailure failure) {
    final serverMessage = failure.serverMessage;
    if (serverMessage != null && serverMessage.isNotEmpty) return serverMessage;

    return switch (failure.kind) {
      AiFailureKind.diagnoseUnavailable => l10n.aiDiagnosisUnavailable,
      AiFailureKind.applyServiceFailed => l10n.aiApplyServiceFailed,
      AiFailureKind.conversationLoop => l10n.aiConversationLoopError,
    };
  }

  String _hintFor(AppLocalizations l10n, AiChatState state) {
    if (_isBlockedByError(state)) return l10n.aiChatErrorHint;

    return switch (state.status) {
      AiChatStatus.awaitingAnswer => l10n.aiChatAnswerHint,
      AiChatStatus.finished => l10n.aiChatFinishedHint,
      _ => l10n.aiChatDescribeProblemHint,
    };
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppLocalizations l10n) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.surfaceWhite,
      flexibleSpace: const DecoratedBox(
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              color: AppColors.surfaceWhite,
              size: 18.r,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            l10n.aiAssistant,
            style: TextStyles.Size18
                .withWeight(FontWeight.bold)
                .withColor(AppColors.surfaceWhite),
          ),
        ],
      ),
      actions: [
        BlocBuilder<AiChatCubit, AiChatState>(
          builder: (context, state) {
            if (!state.hasConversation) return const SizedBox.shrink();
            return IconButton(
              tooltip: l10n.aiChatNewConversation,
              onPressed: state.isBusy
                  ? null
                  : () => context.read<AiChatCubit>().reset(),
              icon: Icon(Icons.restart_alt_rounded, size: 22.r),
            );
          },
        ),
      ],
    );
  }
}

// ==================== شريط الخطأ مع إعادة المحاولة ====================

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorBanner({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.errorColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.errorColor,
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyles.Size15.withColor(AppColors.darkBlueBlack),
                ),
              ),
            ],
          ),
          if (onRetry != null) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 18.r,
                  color: AppColors.errorColor,
                ),
                label: Text(
                  l10n.retry,
                  style: TextStyles.Size15.withColor(AppColors.errorColor),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
