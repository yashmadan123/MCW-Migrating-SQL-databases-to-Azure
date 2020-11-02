using Microsoft.EntityFrameworkCore;

namespace WideWorldImporters.Web.Data
{
    public class WwiContext : DbContext
    {
        public WwiContext(DbContextOptions<WwiContext> options) : base(options)
        {
        }


        public DbSet<Game> Games { get; set; }
    }
}
