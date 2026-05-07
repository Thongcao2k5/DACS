using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class FlashSaleService : IFlashSaleService
    {
        private readonly IUnitOfWork _uow;
        private readonly IMapper _mapper;

        public FlashSaleService(IUnitOfWork uow, IMapper mapper)
        {
            _uow = uow;
            _mapper = mapper;
        }

        public async Task<List<FlashSaleDto>> GetActiveFlashSalesAsync()
        {
            var now = DateTime.Now;
            var activeSales = await _uow.Repository<FlashSale>()
                .Find(f => f.IsActive && f.StartDate <= now && f.EndDate >= now)
                .AsNoTracking()
                .Include(f => f.FlashSaleProducts)
                    .ThenInclude(fp => fp.Product!)
                        .ThenInclude(p => p.Images)
                .Include(f => f.FlashSaleProducts)
                    .ThenInclude(fp => fp.Product!)
                        .ThenInclude(p => p.Variants)
                .ToListAsync();

            var dtos = new List<FlashSaleDto>();

            foreach (var sale in activeSales)
            {
                var dto = _mapper.Map<FlashSaleDto>(sale);
                dto.Products = sale.FlashSaleProducts.Select(fp => {
                    var pDto = _mapper.Map<ProductDto>(fp.Product!);
                    pDto.IsFlashSale = true;
                    pDto.FlashSalePrice = fp.FlashSalePrice;
                    pDto.FlashSaleQuantity = fp.Quantity;
                    pDto.FlashSaleSoldQuantity = fp.SoldQuantity;
                    pDto.FlashSaleEndDate = sale.EndDate;
                    return pDto;
                }).ToList();
                dtos.Add(dto);
            }

            return dtos;
        }

        public async Task<FlashSaleDto?> GetFlashSaleDetailsAsync(int id)
        {
            var sale = await _uow.Repository<FlashSale>()
                .Find(f => f.FlashSaleId == id)
                .AsNoTracking()
                .Include(f => f.FlashSaleProducts)
                    .ThenInclude(fp => fp.Product!)
                        .ThenInclude(p => p.Images)
                .Include(f => f.FlashSaleProducts)
                    .ThenInclude(fp => fp.Product!)
                        .ThenInclude(p => p.Variants)
                .FirstOrDefaultAsync();

            if (sale == null) return null;

            var dto = _mapper.Map<FlashSaleDto>(sale);
            dto.Products = sale.FlashSaleProducts.Select(fp => {
                var pDto = _mapper.Map<ProductDto>(fp.Product!);
                pDto.IsFlashSale = true;
                pDto.FlashSalePrice = fp.FlashSalePrice;
                pDto.FlashSaleQuantity = fp.Quantity;
                pDto.FlashSaleSoldQuantity = fp.SoldQuantity;
                pDto.FlashSaleEndDate = sale.EndDate;
                return pDto;
            }).ToList();

            return dto;
        }
    }
}
