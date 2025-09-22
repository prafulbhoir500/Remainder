---
## ⚙️ Command: Scaffold-DbContext

```powershell
Scaffold-DbContext -Connection name=DefaultConnection Microsoft.EntityFrameworkCore.SqlServer -OutputDir "../ReminderApp.Domain/Entities" -Namespace ReminderApp.Domain -ContextDir "Data" -Context "AppDbContext" -ContextNamespace ReminderApp.Infrastructure -Project ReminderApp.Infrastructure -StartupProject Remainder.API -Force
```
