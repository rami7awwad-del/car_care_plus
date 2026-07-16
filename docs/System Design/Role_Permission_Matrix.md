# Role Matrix & Permission Matrix

## Car Service Management System

### Role Matrix

| Role              | Description                                                                                                                         |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------- |

| Super Admin       | Full system ownership, manages admins, roles, permissions, system settings, and has unrestricted access to all modules and reports. |

| Admin             | Manages daily operations, services, employees, workshops, packages, materials, reports, and customer-related activities.            |

| Guest User        | Unregistered visitor who can register and access public entry points.                                                               |

| Customer-Personal | Individual customer who manages vehicles, bookings, payments, assistance requests, and profile data.                                |

| Customer-Company  | Company customer who manages fleets and multi-vehicle bookings.                                                                     |

| Employee-Washer   | Service employee responsible for cleaning services, task execution, status updates, and material management.                        |

| Employee-Mechanic | Mechanic responsible for inspections, diagnostics, technical reports, and problem reporting.                                        |

| System            | Automated services such as notifications, calculations, AI recommendations, scheduling, tracking, and reporting.                    |

---

## Permission Matrix

| Permission / Function                    | Guest | Customer-Personal | Customer-Company | Employee-Washer | Employee-Mechanic |         Admin | Super Admin | System |
| ---------------------------------------- | :---: | :---------------: | :--------------: | :-------------: | :---------------: |          :---: | :---------: | :----: |
| Register Account                         |   ✅   |         ✅         |         ❌        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Login / Logout                           |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Reset Password                           |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Manage Profile                           |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Manage Vehicles                          |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Add Vehicle Information                  |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| View Services                            |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Book Cleaning Service                    |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| VIP Cleaning Selection                   |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Select Additional Services               |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Request Additional Materials             |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Confirm Material Requests                |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Make Payment                             |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Cash Payment                             |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Package Payment                          |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Points Payment                           |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Road Assistance Request                  |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Search Workshops                         |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ❌   |      ❌      |    ❌   |
| View Workshop Profile                    |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Track Service Status                     |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ✅   |
| Track Employee Location                  |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ✅   |
| Receive Notifications                    |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ✅   |      ✅      |    ✅   |
| Rate Employee                            |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| View Points                              |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| View Packages                            |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Purchase Packages                        
| View Monthly Reports                     |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ✅   |
| Multi-Vehicle Booking                    |   ❌   |         ❌         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| View Assigned Tasks                      |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Filter Tasks                             |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| View Task Details                        |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Update Service Status                    |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Update Material Usage                    |   ❌   |         ❌         |         ❌        |        ✅        |         ❌         |   ✅   |      ✅      |    ❌   |
| Request Materials From Company           |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Request Materials Approval From Customer |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ❌   |      ❌      |    ❌   |
| Confirm Cash Payment Received            |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| View Ratings                             |   ❌   |         ✅         |         ✅        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Add Problem Report                       |   ❌   |         ❌         |         ❌        |        ✅        |         ✅         |   ✅   |      ✅      |    ❌   |
| Manage Users                             |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Manage Employees                         |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Manage Services                          |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Manage Packages                          |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Manage Workshops                         |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Manage Pricing Rules                     |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ❌   |
| Generate Reports                         |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ✅   |
| Send Notifications                       |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ✅   |      ✅      |    ✅   |
| AI Recommendations & Diagnostics         |   ❌   |         ✅         |         ✅        |        ❌        |         ❌         |   ✅   |      ✅      |    ✅   |
| Manage Admins                            |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ❌   |      ✅      |    ❌   |
| Manage Roles & Permissions               |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ❌   |      ✅      |    ❌   |
| Manage System Settings                   |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ❌   |      ✅      |    ❌   |
| Full System Access                       |   ❌   |         ❌         |         ❌        |        ❌        |         ❌         |   ❌   |      ✅      |    ❌   |
