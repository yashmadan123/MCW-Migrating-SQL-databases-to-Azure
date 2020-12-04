using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using WideWorldImporters.Web.Data;

namespace WideWorldImporters.Web.Pages
{
    public class IndexModel : PageModel
    {
        private readonly WwiContext _context;

        private readonly ILogger<IndexModel> _logger;

        public IndexModel(WwiContext context, ILogger<IndexModel> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task OnGetAsync()
        {
            Games = await _context.Games.ToListAsync();
        }

        [BindProperty]
        public IEnumerable<Game> Games { get; set; }
    }
}
