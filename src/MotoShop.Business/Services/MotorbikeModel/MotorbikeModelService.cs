using MotoShop.Business.DTOs;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public interface IMotorbikeModelService
    {
        Task<IEnumerable<MotorbikeModelDto>> GetAllAsync();
        Task<MotorbikeModelDto?> GetByIdAsync(int id);
        Task<bool> CreateAsync(MotorbikeModelDto modelDto);
        Task<bool> UpdateAsync(MotorbikeModelDto modelDto);
        Task<bool> DeleteAsync(int id);
    }

    public class MotorbikeModelService : IMotorbikeModelService
    {
        private readonly IUnitOfWork _uow;
        private readonly IMapper _mapper;

        public MotorbikeModelService(IUnitOfWork uow, IMapper mapper)
        {
            _uow = uow;
            _mapper = mapper;
        }

        public async Task<IEnumerable<MotorbikeModelDto>> GetAllAsync()
        {
            var models = await _uow.Repository<MotorbikeModel>().GetAllAsync();
            return _mapper.Map<IEnumerable<MotorbikeModelDto>>(models);
        }

        public async Task<MotorbikeModelDto?> GetByIdAsync(int id)
        {
            var model = await _uow.Repository<MotorbikeModel>().GetByIdAsync(id);
            return _mapper.Map<MotorbikeModelDto>(model);
        }

        public async Task<bool> CreateAsync(MotorbikeModelDto modelDto)
        {
            var model = _mapper.Map<MotorbikeModel>(modelDto);
            await _uow.Repository<MotorbikeModel>().AddAsync(model);
            return await _uow.CompleteAsync() > 0;
        }

        public async Task<bool> UpdateAsync(MotorbikeModelDto modelDto)
        {
            var model = _mapper.Map<MotorbikeModel>(modelDto);
            _uow.Repository<MotorbikeModel>().Update(model);
            return await _uow.CompleteAsync() > 0;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            await _uow.Repository<MotorbikeModel>().DeleteAsync(id);
            return await _uow.CompleteAsync() > 0;
        }
    }
}
