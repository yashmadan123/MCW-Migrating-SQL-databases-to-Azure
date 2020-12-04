using Microsoft.EntityFrameworkCore;

namespace WideWorldImporters.Web.Data
{
    public class WwiReadOnlyContext : DbContext
    {
        public WwiReadOnlyContext(DbContextOptions<WwiReadOnlyContext> options) : base(options)
        {
        }


        public DbSet<Gamer> Gamers { get; set; }
        public DbSet<Leaderboard> Leaderboard { get; set; }
        public DbSet<UpdateabilityMessage> Updateability { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UpdateabilityMessage>().HasNoKey();
        }
    }
}
