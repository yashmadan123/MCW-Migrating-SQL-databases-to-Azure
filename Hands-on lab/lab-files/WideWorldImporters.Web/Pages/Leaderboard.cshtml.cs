using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using WideWorldImporters.Web.Data;

namespace WideWorldImporters.Web.Pages
{
    public class LeaderboardModel : PageModel
    {
        private readonly WwiReadOnlyContext _context;

        public LeaderboardModel(WwiReadOnlyContext context)
        {
            _context = context;
        }

        public IList<LeaderboardViewModel> Leaderboard { get;set; }

        public void OnGet()
        {
            ViewData["UpdateabilityMessage"] = GetUpdateabilityMessage();

            var topScore = _context.Leaderboard.Max(s => s.GamerScore);

            var lbQuery = from l in _context.Leaderboard
                          join g in _context.Gamers on l.GamerId equals g.Id
                          orderby l.GamerScore descending
                          select new LeaderboardViewModel
                          {
                              GamerTag = g.Tag,
                              Name = $"{g.FirstName} {g.LastName}",
                              GamerScore = l.GamerScore,
                              Diff = l.GamerScore - topScore,
                              GamesPlayed = l.GamesPlayed,
                              IsOnline = l.IsOnline
                          };

            // Return the top 100 players
            var leaderboard = lbQuery.Take(100).AsEnumerable()
                .Select((player, index) => new LeaderboardViewModel
                {
                    Position = index + 1,
                    GamerTag = player.GamerTag,
                    Name = player.Name,
                    GamerScore = player.GamerScore,
                    Diff = player.Diff,
                    GamesPlayed = player.GamesPlayed,
                    IsOnline = player.IsOnline
                })
                .ToList();

            Leaderboard = leaderboard;
        }

        private string GetUpdateabilityMessage()
        {
            var results = _context.Updateability.FromSqlRaw("SELECT DATABASEPROPERTYEX(DB_NAME(), 'Updateability') AS Message");
            return results.First().Message;
        }
    }

    public class LeaderboardViewModel
    {
        public int Position { get; set; }
        [DisplayName("Gamer Tag")]
        public string GamerTag { get; set; }
        public string Name { get; set; }
        [DisplayName("Score")]
        public int GamerScore { get; set; }
        public int Diff { get; set; }
        [DisplayName("Games Played")]
        public int GamesPlayed { get; set; }
        [DisplayName("Online")]
        public bool IsOnline { get; set; }
    }
}
