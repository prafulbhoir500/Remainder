using Microsoft.EntityFrameworkCore;
using Remainder.API.Entities;

namespace Remainder.API.Data
{
    public class AppDbContext(DbContextOptions options) : DbContext(options)
    {
        public DbSet<User> Users { get; set; }
    }
}
