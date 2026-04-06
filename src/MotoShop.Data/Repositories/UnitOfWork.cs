using MotoShop.Data.Data;
using MotoShop.Data.Interfaces;
using System;
using System.Collections;
using System.Threading.Tasks;

namespace MotoShop.Data.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly MotoShopDbContext _context;
        private Hashtable _repositories;

        public UnitOfWork(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<int> CompleteAsync()
        {
            return await _context.SaveChangesAsync();
        }

        public void Dispose()
        {
            _context.Dispose();
        }

        public IGenericRepository<TEntity> Repository<TEntity>() where TEntity : class
        {
            if (_repositories == null) _repositories = new Hashtable();

            var type = typeof(TEntity).Name;

            if (!_repositories.ContainsKey(type))
            {
                var repositoryType = typeof(GenericRepository<>);
                var repositoryInstance = Activator.CreateInstance(repositoryType.MakeGenericType(typeof(TEntity)), _context);

                _repositories.Add(type, repositoryInstance);
            }

            return (IGenericRepository<TEntity>)_repositories[type];
        }
    }
}
