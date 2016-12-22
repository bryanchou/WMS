<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/commons/basejs.jsp" %>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>用户管理</title>
    <script type="text/javascript">

        var dataGrid;
        var organizationTree;

        $(function() {

            dataGrid = $('#dataGrid').datagrid({
                url : '${path }/borrow/selectByPage',
                fit : true,
                striped : true,
                rownumbers : true,
                pagination : true,
                singleSelect : true,
                height : '27',
                idField : 'id',
                sortName : 'id',
                sortOrder : 'asc',
                pageSize : 20,
                pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500 ],
                columns : [ [ {
                    width : '100',
                    title : '货物名称',
                    field : 'cbName',
                    sortable : true
                }, {
                    width : '100',
                    title : '货物型号',
                    field : 'cbSkumodel',
                    sortable : true
                },{
                    width : '80',
                    title : '数量',
                    field : 'cbNum',
                    sortable : true
                },  {
                    width : '180',
                    title : '原因',
                    field : 'cbCause',
                    sortable : true
                }, {
                    width : '70',
                    title : '借用人',
                    field : 'cbNames',
                    sortable : true
                },{
                    width : '150',
                    title : '时间',
                    field : 'cbTime',
                    sortable : true
                }, {
                        field : 'action',
                        title : '操作',
                        width : 130,
                        formatter : function(value, row, index) {
                            var str = '';
                            <shiro:hasPermission name="/user/edit">
                            str += $.formatString('<a style="height:24px;" href="javascript:void(0)" class="user-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
                            </shiro:hasPermission>
                            <shiro:hasPermission name="/user/delete">
                            str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                            str += $.formatString('<a style="height:24px;" href="javascript:void(0)" class="user-easyui-linkbutton-del" data-options="plain:true,iconCls:\'icon-del\'" onclick="deleteFun(\'{0}\');" >删除</a>', row.id);
                            </shiro:hasPermission>
                            return str;
                        }
                }] ],
                onLoadSuccess:function(data){
                    $('.user-easyui-linkbutton-edit').linkbutton({text:'编辑',plain:true,iconCls:'icon-edit'});
                    $('.user-easyui-linkbutton-del').linkbutton({text:'删除',plain:true,iconCls:'icon-del'});
                },
                toolbar : '#toolbar'
            });
        });

        function addFun() {
            parent.$.modalDialog({
                title : '新增货物借出单',
                width : 500,
                height : 300,
                href : '${path }/borrow/borrowaddpage',
                buttons : [ {
                    text : '添加',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#cargoborrwAddForm');
                        f.submit();
                    }
                } ]
            });
        }

        function deleteFun(id) {
            if (id == undefined) {//点击右键菜单才会触发这个
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            } else {//点击操作里面的删除图标会触发这个
                dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
            }
            parent.$.messager.confirm('询问', '您是否要删除当前用户？', function(b) {
                if (b) {
                    var currentUserId = '${sessionInfo.id}';/*当前登录用户的ID*/
                    if (currentUserId != id) {
                        progressLoad();
                        $.post('${path }/user/delete', {
                            id : id
                        }, function(result) {
                            if (result.success) {
                                parent.$.messager.alert('提示', result.msg, 'info');
                                dataGrid.datagrid('reload');
                            }
                            progressClose();
                        }, 'JSON');
                    } else {
                        parent.$.messager.show({
                            title : '提示',
                            msg : '不可以删除自己！'
                        });
                    }
                }
            });
        }

        function editFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            } else {
                dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
            }
            parent.$.modalDialog({
                title : '编辑',
                width : 500,
                height : 300,
                href : '${path }/user/editPage?id=' + id,
                buttons : [ {
                    text : '确定',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#userEditForm');
                        f.submit();
                    }
                } ]
            });
        }

        function searchFun() {
            dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
        }
        function cleanFun() {
            $('#searchForm input').val('');
            dataGrid.datagrid('load', {});
        }
    </script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
<div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
    <form id="searchForm">
        <table>
            <tr>
                <th>货物型号:</th>
                <td><input name="cbSkumodel" placeholder="请输入货物型号"/></td>
                <th>创建时间:</th>
                <td>
                    <input name="createdateStart" placeholder="点击选择时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" />至<input  name="createdateEnd" placeholder="点击选择时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" readonly="readonly" />
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="cleanFun();">清空</a>
                </td>
            </tr>
        </table>
    </form>
</div>
<div data-options="region:'center',border:true,title:'货品借出登记表'" >
    <table id="dataGrid" data-options="fit:true,border:false"></table>
</div>
<div id="toolbar" style="display: none;">
    <shiro:hasPermission name="/borrow/add">
        <a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">新增货物借出单</a>
    </shiro:hasPermission>
</div>
</body>
</html>