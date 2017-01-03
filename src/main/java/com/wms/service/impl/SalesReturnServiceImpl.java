package com.wms.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.plugins.Page;
<<<<<<< Updated upstream
=======
import com.wms.bean.Allotput;
>>>>>>> Stashed changes
import com.wms.bean.SalesReturn;
import com.wms.commons.utils.PageInfo;
import com.wms.dao.SalesReturnMapper;
import com.wms.service.SalesReturnService;

@Service
public class SalesReturnServiceImpl implements SalesReturnService {

	@Autowired
	private SalesReturnMapper salesReturn;
	
	@Override
	public int deleteByPrimaryKey(Integer srId) {
		return salesReturn.deleteByPrimaryKey(srId);
	}

	@Override
	public int insert(SalesReturn record) {
		return salesReturn.insert(record);
	}

	@Override
	public int insertSelective(SalesReturn record) {
		return salesReturn.insertSelective(record);
	}

	@Override
<<<<<<< Updated upstream
	public SalesReturn selectByPrimaryKey(Integer srId) {
=======
	public List<SalesReturn> selectByPrimaryKey(Integer srId) {
>>>>>>> Stashed changes
		return salesReturn.selectByPrimaryKey(srId);
	}

	@Override
	public void selectAll(PageInfo pageinfo) {
		Page<SalesReturn> page  = new Page<SalesReturn>(pageinfo.getNowpage(),pageinfo.getPagesize());
<<<<<<< Updated upstream
		List<SalesReturn> list = salesReturn.selectAll(page,pageinfo.getCondition());
=======
		List<SalesReturn> list = salesReturn.selectAll(page);
>>>>>>> Stashed changes
		pageinfo.setRows(list);
		pageinfo.setTotal(page.getTotal());
	}

	@Override
	public int updateByPrimaryKeySelective(SalesReturn record) {
		return salesReturn.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(SalesReturn record) {
		return salesReturn.updateByPrimaryKey(record);
	}

}
