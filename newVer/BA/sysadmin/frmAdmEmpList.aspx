<%@ Page Language="C#" AutoEventWireup="true" validateRequest="false" CodeFile="frmAdmEmpList.aspx.cs" Inherits="BA_sysadmin_frmAdmEmpList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>员工信息</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <link rel="stylesheet" type="text/css" href="../../ext3/resources/css/ext-all.css" />
    <link rel="Stylesheet" type="text/css" href="../../css/columnLock.css" />
    <script type="text/javascript" src="../../ext3/adapter/ext/ext-base.js"></script>

    <script type="text/javascript" src="../../ext3/ext-all.js"></script>
    <script type="text/javascript" src="../../js/operateResp.js"></script>
    <script type="text/javascript" src="../../js/FilterControl.js"></script>
    <script type="text/javascript" src="../../js/columnLock.js"></script>
    <script type="text/javascript" src="../../js/ExtJsHelper.js"></script>
    <script type="text/javascript" src="../../js/DeptPosition.js"></script>
    <script type="text/javascript" src="../../js/getExcelXml.js"></script>
    <script type="text/javascript" src="../../js/GroupFieldSelect.js"></script>
<%=getComboBoxSource() %>
    <script type="text/javascript">
    Ext.BLANK_IMAGE_URL = "../../ext3/resources/images/default/s.gif"
    function getCmbStore(columnName)
    {
        switch(columnName)
        {
            case "EmpSex":
                return EmpSexStore;
            case "EmpState":
                return EmpStateStore;
            case "EmpBz":
                return EmpBzStore;
        }
        return null;
    }
        var saveType = "";
        var formTitle = "";
        var imageUrl = "../../Theme/1/";
        Ext.onReady(function() {
            /*------实现toolbar的函数 start---------------*/
            var Toolbar = new Ext.Toolbar({
                renderTo: 'toolbar',
                region: "north",
                height: 25,
                items: [{
                    text: "新增",
                    icon: imageUrl + "images/extjs/customer/add16.gif",
                    handler: function() {
                        saveType = "add";
                        openAddEmployeeWin();
                        AddKeyDownEvent('divEmp');



                    }
                }, '-', {
                    text: "编辑",
                    icon: imageUrl + "images/extjs/customer/edit16.gif",
                    handler: function() {
                        saveType = "editemp";
                        modifyEmployeeWin();
                        AddKeyDownEvent('divEmp')
                    }
//                }, '-', {
//                    text: "删除",
//                    icon: imageUrl + "images/extjs/customer/delete16.gif",
//                    handler: function() {
//                        deleteEmployee();
//                    }
                }, '-', {
                    text: "创建用户",
                    icon: imageUrl + "images/extjs/customer/delete16.gif",
                    handler: function() {
                        modifyUserWin();
                        //                        var sm = Ext.getCmp('empGrid').getSelectionModel();
                        //                        //获取选择的数据信息
                        //                        var selectData = sm.getSelected();
                        //                        if (selectData == null) {
                        //                            Ext.Msg.alert("提示", "请选中需要创建用户的员工信息！");
                        //                        return;
                        //                        }
                        //                        Ext.getCmp("UserRealname").setValue(selectData.data.EmpName);
                        //                        uploadUserWindow.show();
                    }
}]
                });

               
                /*------结束toolbar的函数 end---------------*/


                /*------开始ToolBar事件函数 start---------------*//*-----新增Employee实体类窗体函数----*/
                function openAddEmployeeWin() {
                    Ext.getCmp('EmpId').setValue("0"),
	Ext.getCmp('EmpCode').setValue(""),
	Ext.getCmp('EmpName').setValue(""),
	Ext.getCmp('EmpSex').setValue(""),
	Ext.getCmp('EmpBirthday').setValue(""),
	Ext.getCmp('EmpEducation').setValue(""),
	Ext.getCmp('EmpDegree').setValue(""),
	Ext.getCmp('EmpGraduationdate').setValue(""),
	Ext.getCmp('EmpProfessional').setValue(""),
	Ext.getCmp('EmpPolitical').setValue(""),
	Ext.getCmp('DeptId').setValue(""),
	Ext.getCmp('OrgId').setValue(orgId),
	Ext.getCmp('EmpJob').setValue(""),
	Ext.getCmp('EmpJoindate').setValue(""),
//	Ext.getCmp('EmpBz').setValue(""),
	Ext.getCmp('EmpState').setValue(""),
	Ext.getCmp('EmpAddress').setValue(""),
	Ext.getCmp('EmpPhone').setValue(""),
	Ext.getCmp('EmpMobil').setValue(""),
	Ext.getCmp('EmpMemo').setValue(""),
	uploadEmployeeWindow.show();
                }
                /*-----编辑Employee实体类窗体函数----*/
                function modifyEmployeeWin() {
                    var sm = Ext.getCmp('empGrid').getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要编辑的员工信息！");
                        return;
                    }
                    setFormValue(selectData);
                    uploadEmployeeWindow.show();

                }
                /*-----删除Employee实体函数----*/
                /*删除信息*/
                function deleteEmployee() {
                    var sm = Ext.getCmp('empGrid').getSelectionModel();
                    //获取选择的数据信息
                    var selectData = sm.getSelected();
                    //如果没有选择，就提示需要选择数据信息
                    if (selectData == null) {
                        Ext.Msg.alert("提示", "请选中需要删除的信息！");
                        return;
                    }
                    //删除前再次提醒是否真的要删除
                    Ext.Msg.confirm("提示信息", "是否真的要删除选择的员工信息吗？", function callBack(id) {
                        //判断是否删除数据
                        if (id == "yes") {
                            //页面提交
                            Ext.Ajax.request({
                                url: 'frmAdmEmpList.aspx?method=deleteemp',
                                method: 'POST',
                                params: {
                                    EmpId: selectData.data.EmpId
                                },
                                success: function(resp, opts) {
                                    if (checkExtMessage(resp)) {
                                        empGridData.reload();
                                    }
                                },
                                failure: function(resp, opts) {
                                    Ext.Msg.alert("提示", "数据删除失败");
                                }
                            });
                        }
                    });
                }

                /*------实现FormPanle的函数 start---------------*/
                var divEmp = new Ext.form.FormPanel({
                    frame: true,
                    title: '',
                    items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '标识',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'EmpId',
				    id: 'EmpId',
				    hide: true
				}
		]
		}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '编号',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpCode',
				    id: 'EmpCode'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '姓名',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpName',
				    id: 'EmpName'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'combo',
				    store: EmpSexStore,
				    fieldLabel: '性别',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpSex',
				    id: 'EmpSex',
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '请选择性别信息',
				    triggerAction: 'all'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '出生日期',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpBirthday',
				    id: 'EmpBirthday',
				    format: "Y年m月d日"
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '学历',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpEducation',
				    id: 'EmpEducation'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '学位',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpDegree',
				    id: 'EmpDegree'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '毕业时间',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpGraduationdate',
				    id: 'EmpGraduationdate',
				    format: "Y年m月"
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '专业',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpProfessional',
				    id: 'EmpProfessional'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'combo',
				    store: EmpPoliticalStore,
				    fieldLabel: '政治面貌',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpPolitical',
				    id: 'EmpPolitical',
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '请选择政治面貌信息',
				    triggerAction: 'all'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '部门',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'DeptId',
				    id: 'DeptId',
				    store: DeptIdStore,
				    displayField: 'DeptName',
				    valueField: 'DeptId',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '请选择部门信息',
				    triggerAction: 'all'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.67,
    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '机构ID',
				    //columnWidth: 0.67,
				    anchor: '90%',
				    name: 'OrgId',
				    id: 'OrgId'
				},
				{
				    xtype: 'textfield',
				    fieldLabel: '机构名称',
				    //columnWidth: 0.67,
				    anchor: '90%',
				    name: 'OrgName',
				    id: 'OrgName',
				    readOnly: true,
				    value: orgName
				}

		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '岗位',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpJob',
				    id: 'EmpJob'
				}
				, {
				    xtype: 'textfield',
				    fieldLabel: '岗位',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpJobName',
				    id: 'EmpJobName'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '入职时间',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpJoindate',
				    id: 'EmpJoindate',
				    format: "Y年m月d日"
				}
		]
}
//, {
//    layout: 'form',
//    border: false,
//    columnWidth: 0.33,
//    items: [
//				{
//				    xtype: 'combo',
//				    fieldLabel: '编制',
//				    columnWidth: 0.33,
//				    anchor: '90%',
//				    name: 'EmpBz',
//				    id: 'EmpBz',
//				    store: EmpBzStore,
//				    displayField: 'DicsName',
//				    valueField: 'OrderIndex',
//				    typeAhead: true,
//				    mode: 'local',
//				    emptyText: '请选择编制信息',
//				    triggerAction: 'all'
//				}
//		]
//}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'combo',
				    store: EmpStateStore,
				    fieldLabel: '在职状态',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpState',
				    id: 'EmpState',
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '请选择在职状态信息',
				    triggerAction: 'all'

				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.67,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '家庭地址',
				    columnWidth: 0.67,
				    anchor: '90%',
				    name: 'EmpAddress',
				    id: 'EmpAddress'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '：',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '联系电话',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpPhone',
				    id: 'EmpPhone'
				}
		]
		}
, {
    layout: 'form',
    border: false,
    columnWidth: 0.33,
    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '手机',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpMobil',
				    id: 'EmpMobil'
				}
		]
}
, {
    layout: 'form',
    border: false,
    columnWidth: 1,
    items: [
				{
				    xtype: 'textarea',
				    fieldLabel: '备注',
				    columnWidth: 1,
				    anchor: '90%',
				    name: 'EmpMemo',
				    id: 'EmpMemo'
				}
		]
}
	]
	}
]
                });
                /*------FormPanle的函数结束 End---------------*/
                Ext.getCmp("EmpJobName").on("focus", selectEmp);
                function selectEmp(v) {
                    if (selectPositionForm == null) {
                        showPositionForm(0, '岗位选择', 'frmAdmEmpList.aspx?method=getpositiontreecolumnlist');
                        Ext.getCmp("btnOk").on("click", selectOK);
                    }
                    else {
                        showPositionForm(0, '岗位选择', 'frmAdmEmpList.aspx?method=getpositiontreecolumnlist');
                    }
                }

                function selectOK() {
                    var selectNodes = selectPositionTree.getChecked();
                    if (selectNodes.length > 0) {

                        Ext.getCmp("EmpJob").setValue(selectNodes[0].id);
                        Ext.getCmp("EmpJobName").setValue(selectNodes[0].text);
                        //Ext.getCmp("AccepterId").setValue(selectNodes[0].id);
                    }
                }


                //保存数据信息
                function saveEmpData() {
                    getFormValue();
                }
                /*------开始界面数据的窗体 Start---------------*/
                if (typeof (uploadEmployeeWindow) == "undefined") {//解决创建2个windows问题
                    uploadEmployeeWindow = new Ext.Window({
                        id: 'Employeeformwindow',
                        title: formTitle
		, iconCls: 'upload-win'
		, width: 800
		, height: 360
		, layout: 'fit'
		, plain: true
		, modal: true
		, x: 50
		, y: 50
		, constrain: true
		, resizable: false
		, closeAction: 'hide'
		, autoDestroy: true
		, items: divEmp
		, buttons: [{
		    text: "保存"
			, handler: function() {
			    saveEmpData();
			}
			, scope: this
		},
		{
		    text: "取消"
			, handler: function() {
			    uploadEmployeeWindow.hide();
			}
			, scope: this
}]
                    });
                }
                uploadEmployeeWindow.addListener("hide", function() {
                });

                // Create a KeyMap
                //var map = new Ext.KeyMap(empGrid, {
                //    key: Ext.EventObject.ENTER,
                //    fn: function(){ alert('ok');return Ext.EventObject.TAB} 
                //});



                function handleKey(key) {

                }

                /*------开始获取界面数据的函数 start---------------*/
                function getFormValue() {
                    Ext.MessageBox.wait("数据正在保存，请稍后……");
                    var dateEmpBirthday = Ext.get("EmpBirthday").getValue();
                    //                    if (dateEmpBirthday != '')
                    //                        dateEmpBirthday = dateEmpBirthday.toLocaleDateString();
                    var dateEmpGraduationdate = Ext.get("EmpGraduationdate").getValue();
                    //                    if (dateEmpGraduationdate != '')
                    //                        dateEmpGraduationdate = dateEmpGraduationdate.toLocaleDateString();
                    var dateEmpJoindate = Ext.get("EmpJoindate").getValue();
                    //                    if (dateEmpJoindate != '')
                    //                        dateEmpJoindate = dateEmpJoindate.toLocaleDateString();
                    Ext.Ajax.request({
                        url: 'frmAdmEmpList.aspx?method=' + saveType,
                        method: 'POST',
                        params: {
                            EmpId: Ext.getCmp('EmpId').getValue(),
                            EmpCode: Ext.getCmp('EmpCode').getValue(),
                            EmpName: Ext.getCmp('EmpName').getValue(),
                            EmpSex: Ext.getCmp('EmpSex').getValue(),
                            EmpBirthday: dateEmpBirthday,
                            EmpEducation: Ext.getCmp('EmpEducation').getValue(),
                            EmpDegree: Ext.getCmp('EmpDegree').getValue(),
                            EmpGraduationdate: dateEmpGraduationdate,
                            EmpProfessional: Ext.getCmp('EmpProfessional').getValue(),
                            EmpPolitical: Ext.getCmp('EmpPolitical').getValue(),
                            DeptId: Ext.getCmp('DeptId').getValue(),
                            OrgId: orgId, //Ext.getCmp('OrgId').getValue(),
                            EmpJob: Ext.getCmp('EmpJob').getValue(),
                            EmpJoindate: dateEmpJoindate,
			    EmpBz:'',
//                            EmpBz: Ext.getCmp('EmpBz').getValue(),
                            EmpState: Ext.getCmp('EmpState').getValue(),
                            EmpAddress: Ext.getCmp('EmpAddress').getValue(),
                            EmpPhone: Ext.getCmp('EmpPhone').getValue(),
                            EmpMobil: Ext.getCmp('EmpMobil').getValue(),
                            EmpMemo: Ext.getCmp('EmpMemo').getValue()
                        },
                        success: function(resp, opts) {
                            Ext.MessageBox.hide();
                            if (checkExtMessage(resp)) {
                                uploadEmployeeWindow.hide();
                                empGridData.reload();
                            }
                        },
                        failure: function(resp, opts) {
                            Ext.MessageBox.hide();
                            Ext.Msg.alert("提示", "保存失败");
                        }
                    });
                }
                /*------结束获取界面数据的函数 End---------------*/

                /*------开始界面数据的函数 Start---------------*/
                function setFormValue(selectData) {
                    Ext.Ajax.request({
                        url: 'frmAdmEmpList.aspx?method=getemployee',
                        params: {
                            EmpId: selectData.data.EmpId
                        },
                        success: function(resp, opts) {
                            var data = Ext.util.JSON.decode(resp.responseText);
                            Ext.getCmp("EmpId").setValue(data.EmpId);
                            Ext.getCmp("EmpCode").setValue(data.EmpCode);
                            Ext.getCmp("EmpName").setValue(data.EmpName);
                            if(data.EmpSex=="0")
                            {
                                Ext.getCmp("EmpSex").setValue("");
                            }
                            else
                            {
                                Ext.getCmp("EmpSex").setValue(data.EmpSex);
                            }
                            
//                            alert(data.EmpBirthday);
//                            
//                            Ext.getCmp("EmpBirthday").setValue(data.EmpBirthday);
                            if (data.EmpBirthday != '')
                                Ext.getCmp("EmpBirthday").setValue(new Date(Date.parse(data.EmpBirthday)));
                            else {
                                Ext.getCmp("EmpBirthday").setValue("");
                            }

                            Ext.getCmp("EmpEducation").setValue(data.EmpEducation);
                            Ext.getCmp("EmpDegree").setValue(data.EmpDegree);
                            if (data.EmpGraduationdate != '')
                                Ext.getCmp("EmpGraduationdate").setValue(new Date(Date.parse(data.EmpGraduationdate)));
                            else {
                                Ext.getCmp("EmpGraduationdate").setValue("");
                            }
                            Ext.getCmp("EmpProfessional").setValue(data.EmpProfessional);
                            if(data.EmpPolitical=="0")
                            {
                                Ext.getCmp("EmpPolitical").setValue("");
                            }
                            else
                            {
                                Ext.getCmp("EmpPolitical").setValue(data.EmpPolitical);
                            }
                            
                            if(data.DeptId=="0")
                            {
                                Ext.getCmp("DeptId").setValue("");
                            }
                            else{                            
                                Ext.getCmp("DeptId").setValue(data.DeptId);
                            }
                            Ext.getCmp("OrgId").setValue(data.OrgId);
                            Ext.getCmp("EmpJob").setValue(data.EmpJob);
                            Ext.getCmp("EmpJobName").setValue(data.EmpJobName);
                            if (data.EmpJoindate != '')
                                Ext.getCmp("EmpJoindate").setValue(new Date(Date.parse(data.EmpJoindate)));
                            else {
                                Ext.getCmp("EmpJoindate").setValue("");
                            }
//                            Ext.getCmp("EmpBz").setValue(data.EmpBz);
                            if(data.EmpState=="0")
                            {
                                 Ext.getCmp("EmpState").setValue("");
                            }
                            else
                            {
                                Ext.getCmp("EmpState").setValue(data.EmpState);
                            }
                            Ext.getCmp("EmpAddress").setValue(data.EmpAddress);
                            Ext.getCmp("EmpPhone").setValue(data.EmpPhone);
                            Ext.getCmp("EmpMobil").setValue(data.EmpMobil);
                            Ext.getCmp("EmpMemo").setValue(data.EmpMemo);
                        },
                        failure: function(resp, opts) {
                            Ext.Msg.alert("提示", "获取用户信息失败");
                        }
                    });
                }
                /*------结束设置界面数据的函数 End---------------*/

                function getEmpSex(val) {
                    var index = EmpSexStore.find('OrderIndex', val);
                    if (index < 0)
                        return "";
                    var record = EmpSexStore.getAt(index);
                    return record.data.DicsName;

                }

                function getEmpState(val) {
                    var index = EmpStateStore.find('OrderIndex', val);
                    if (index < 0)
                        return "";
                    var record = EmpStateStore.getAt(index);
                    return record.data.DicsName;
                }

                function getEmpBz(val) {
                    var index = EmpBzStore.find('OrderIndex', val);
                    if (index < 0)
                        return "";
                    var record = EmpBzStore.getAt(index);
                    return record.data.DicsName;
                }

                function getParentDepart(val) {
                    var index = deptGridData.find('DeptId', val);
                    if (index < 0)
                        return "";
                    var record = deptGridData.getAt(index);
                    return record.data.DeptName;

                }
                /*------开始获取数据的函数 start---------------*/
                var empGridData = new Ext.data.Store
({
    url: 'frmAdmEmpList.aspx?method=getemplist',
    reader: new Ext.data.JsonReader({
        totalProperty: 'totalProperty',
        root: 'root'
    }, [
	{
	    name: 'EmpId', type: 'int'
	},
	{
	    name: 'EmpCode'
	},
	{
	    name: 'EmpName'
	},
	{
	    name: 'EmpSex', type: 'int'
	},
	{
	    name: 'EmpBirthday', type: 'date'
	},
	{
	    name: 'EmpEducation'
	},
	{
	    name: 'EmpDegree'
	},
	{
	    name: 'EmpGraduationdate', type: 'date'
	},
	{
	    name: 'EmpProfessional'
	},
	{
	    name: 'EmpPolitical'
	},
	{
	    name: 'DeptId'
	},
	{
	    name: 'OrgId', type: 'int'
	},
	{
	    name: 'EmpJob'
	},
	{
	    name: 'EmpJoindate', type: 'date'
	},
	{
	    name: 'EmpBz'
	},
	{
	    name: 'EmpState'
	},
	{
	    name: 'EmpAddress'
	},
	{
	    name: 'EmpPhone'
	},
	{
	    name: 'EmpMobil'
	},
	{
	    name: 'EmpMemo'
}])
	,
    listeners:
	{
	    scope: this,
	    load: function() {
	    }
	}
});

                empGridData.load({
                    params: {
                        start: 0,
                        limit: 10
                    }
                });
                /*------获取数据的函数 结束 End---------------*/

                var toolBar = new Ext.PagingToolbar({
                    pageSize: 10,
                    store: empGridData,
                    displayMsg: '显示第{0}条到{1}条记录,共{2}条',
                    emptyMsy: '没有记录',
                    displayInfo: true
                });
                var pageSizestore = new Ext.data.SimpleStore({
                    fields: ['pageSize'],
                    data: [[10], [20], [30]]
                });
                var combo = new Ext.form.ComboBox({
                    regex: /^\d*$/,
                    store: pageSizestore,
                    displayField: 'pageSize',
                    typeAhead: true,
                    mode: 'local',
                    emptyText: '更改每页记录数',
                    triggerAction: 'all',
                    selectOnFocus: true,
                    width: 135
                });
                toolBar.addField(combo);
                combo.on("change", function(c, value) {
                    toolBar.pageSize = value;
                    defaultPageSize = toolBar.pageSize;
                    toolBar.doLoad(0);
                }, toolBar);
                combo.on("select", function(c, record) {
                    toolBar.pageSize = parseInt(record.get("pageSize"));
                    defaultPageSize = toolBar.pageSize;
                    toolBar.doLoad(0);
                }, toolBar);
                /*------开始DataGrid的函数 start---------------*/

                var sm = new Ext.grid.CheckboxSelectionModel({
                    singleSelect: true
                });
                var rowNum = new Ext.grid.RowNumberer();
                rowNum.locked = true;
                var empGrid = new Ext.ux.grid.LockingEditorGridPanel({
                    el: 'empGrid',
                    width: document.body.clientWidth-3,
                    height: '100%',

                    //region: "center",
                    //layout: 'fit',
                    stripeRows: true,
                    id: 'empGrid',
                    store: empGridData,
                    loadMask: { msg: '正在加载数据，请稍侯……' },
                    sm: sm,
                    //cm: new Ext.grid.ColumnModel([sm,
                    columns: [sm,
                    rowNum, //自动行号
                    {
                    header: '编号',
                    dataIndex: 'EmpCode',
                    width: 100,
                    locked: true,
                    id: 'EmpCode',
                    locked: true
                },

		{
		    header: '标识',
		    dataIndex: 'EmpId',
		    id: 'EmpId',
		    hidden: true
		},

		{
		    header: '姓名',
		    dataIndex: 'EmpName',
		    width: 100,
		    id: 'EmpName',
		    locked: true
		},
		{
		    header: '性别',
		    dataIndex: 'EmpSex',
		    width: 100,
		    id: 'EmpSex',
		    renderer: getEmpSex
		},
		{
		    header: '出生日期',
		    dataIndex: 'EmpBirthday',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'EmpBirthday'
		},
		{
		    header: '学历',
		    dataIndex: 'EmpEducation',
		    width: 100,
		    id: 'EmpEducation'
		},
		{
		    header: '学位',
		    dataIndex: 'EmpDegree',
		    width: 100,
		    id: 'EmpDegree'
		},
		{
		    header: '毕业时间',
		    dataIndex: 'EmpGraduationdate',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m'),
		    id: 'EmpGraduationdate'
		},
		{
		    header: '专业',
		    dataIndex: 'EmpProfessional',
		    width: 100,
		    id: 'EmpProfessional'
		},
		{
		    header: '政治面貌',
		    dataIndex: 'EmpPolitical',
		    width: 100,
		    id: 'EmpPolitical'
		},
		{
		    header: '岗位',
		    dataIndex: 'EmpJob',
		    id: 'EmpJob'
		},
		{
		    header: '入职时间',
		    dataIndex: 'EmpJoindate',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'EmpJoindate'
		},
		{
		    header: '在职状态',
		    dataIndex: 'EmpState',
		    width: 100,
		    id: 'EmpState',
		    renderer: getEmpState
		},
		{
		    header: '家庭地址',
		    dataIndex: 'EmpAddress',
		    width: 100,
		    id: 'EmpAddress'
		},
		{
		    header: '联系电话',
		    dataIndex: 'EmpPhone',
		    id: 'EmpPhone'
		},
		{
		    header: '手机',
		    dataIndex: 'EmpMobil',
		    width: 100,
		    id: 'EmpMobil'
		},
		{
		    header: '备注',
		    dataIndex: 'EmpMemo',
		    width: 100,
		    id: 'EmpMemo'
}],
                bbar: toolBar,
                viewConfig: {
                    columnsText: '显示的列',
                    scrollOffset: 20,
                    sortAscText: '升序',
                    sortDescText: '降序'

                },
                height: 280
                //                    closeAction: 'hide',
                //                    stripeRows: true,
                //                    loadMask: true,
                //                    autoSizeColumns:false,
                //                    autoExpandColumn: 2
            });
            empGrid.render();

            _grid = empGrid;
            iniSelectColumn(Toolbar, "searchGrid");
            createSearch(empGrid, empGridData, "searchForm");
            btnFliter.on("click", staticSeach);
            //setControlVisibleByField();
            searchForm.el = "searchForm";
            searchForm.render();

            setToolBarVisible(Toolbar);
            function staticSeach() {
                var json = "";
                filterStore.each(function(filterStore) {
                    json += Ext.util.JSON.encode(filterStore.data) + ',';
                });
                searchDataGrid(json);
            }
            function cmbDept(val) {
                var index = DeptIdStore.find('DeptId', val);
                if (index < 0)
                    return "";
                var record = DeptIdStore.getAt(index);
                return record.data.DeptName;
            }
            /*------DataGrid的函数结束 End---------------*/
            /*------ViewPort的设置---------------*/
            //                new Ext.Viewport({ layout: 'border', items: [
            //                    Toolbar, empGrid]
            //                })


            /*创建用户信息*/
            var userForm = new Ext.form.FormPanel({
                region: "north",
                collapsible: true,
                //renderTo:'cc',
                //layout:'fit',
                height: 150,
                id: 'useraddfrom',
                frame: true,
                items: [
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 1,
        items: [{
            xtype: 'textfield',
            fieldLabel: '用户名',
            anchor: '90%',
            id: 'UserName'}]
}]
        },
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 0.5,
        items: [{
            xtype: 'textfield',
            fieldLabel: '真实姓名',
            anchor: '90%',
            id: 'UserRealname'}]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items: [{
                xtype: 'textfield',
                inputType: 'password',
                fieldLabel: '密码',
                anchor: '90%',
                id: 'UserPassword'}]
}]
            },
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 0.5,
        items: [{
            style: 'align:left',
            xtype: 'checkbox',
            fieldLabel: '是否锁定',
            anchor: '90%',
            id: 'UserIslocked',
            name: 'UserIslocked'}]
        }
        , {
            layout: 'form',
            border: false,
            columnWidth: 0.5,
            items: [{
                style: 'align:left',
                xtype: 'checkbox',
                fieldLabel: '是否绑定IP',
                anchor: '90%',
                id: 'UserBindip',
                name: 'UserBindip'}]
}]
            },
{
    layout: 'column',
    border: false,
    items: [{
        layout: 'form',
        border: false,
        columnWidth: 1,
        items: [{
            xtype: 'textfield',
            fieldLabel: 'IP地址',
            anchor: '70%',
            id: 'UserIpaddress'}]
}]
}]
            });
            var selectedUserId = 0;
            /*生成角色选择的Tree树信息******/
            var Tree = Ext.tree;

            var tree = new Tree.TreePanel({
                //el: 'tree-div',
                useArrows: true,
                region: "center",
                autoScroll: true,
                animate: true,
                enableDD: true,
                containerScroll: true,
                //height:150,

                rootVisible: false,

                loader: new Tree.TreeLoader({
                    dataUrl: 'userManager.aspx?method=getRoleByUser'
                })
            });
            tree.getLoader().on("beforeload", function(treeLoader, node) {
                treeLoader.baseParams.UserId = selectedUserId;
            }, this);

            tree.on('checkchange', function(node, checked) {
                node.expand();
                node.attributes.checked = checked;
                node.eachChild(function(child) {
                    child.ui.toggleCheck(checked);
                    child.attributes.checked = checked;
                    child.fireEvent('checkchange', child, checked);
                });
            }, tree);


            // set the root node
            var root = new Tree.AsyncTreeNode({
                text: '角色信息',
                draggable: false,
                id: 'source'
            });
            tree.setRootNode(root);


            //获取选择的节点信息
            function getSelectNodes() {
                var selectNodes = tree.getChecked();
                var ids = "";
                if(selectNodes!=null)
                {
                    for (var i = 0; i < selectNodes.length; i++) {
                        if (ids.length > 0)
                            ids += ",";
                        ids += selectNodes[i].id;
                    }
                }
                return ids;
            }

            //tree刷新
            function treeReLoad(userID) {


            }
            /*****/

            if (typeof (uploadUserWindow) == "undefined") {//解决创建2个windows问题
                uploadUserWindow = new Ext.Window({
                    id: 'userformwindow',
                    title: "新增用户"
	                                                    , iconCls: 'upload-win'
	                                                    , width: 600
	                                                    , height: 450
	                                                    , layout: 'border'
	                                                    , plain: true
	                                                    , modal: true
	                                                    , x: 50
	                                                    , y: 50
	                                                    , constrain: true
	                                                    , resizable: false
	                                                    , closeAction: 'hide'
	                                                    , autoDestroy: true

	                                                   , items: [userForm, tree]
                                                         , buttons: [{
                                                             text: "保存"
		                                                    , handler: function() {
		                                                        //saveUserData();

		                                                        saveUserData();

		                                                    }
			                                                    , scope: this
                                                         },
	                                                    {
	                                                        text: "取消"
		                                                    , handler: function() {
		                                                        uploadUserWindow.hide();
		                                                    }
		                                                    , scope: this
}]
                });
            }

            uploadUserWindow.addListener("hide", function() {
                userForm.getForm().reset();
            });

            /*  修改窗口  */
            function modifyUserWin() {
                var sm = Ext.getCmp('empGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("提示", "请选中需要创建用户的员工信息！");
                    return;
                }
                uploadUserWindow.show();

                Ext.Ajax.request({
                    url: 'frmadmemplist.aspx?method=getuserbyempid',
                    params: {
                        EmpId: selectData.data.EmpId//传入用户seqId
                    },
                    success: function(resp, opts) {
                        //还没有创建用户
                        if (resp.responseText == "") {
                            Ext.getCmp("UserRealname").setValue(selectData.data.EmpName);
                            selectedUserId = 0;
                            tree.root.reload();
                            return;
                        }
                        var data = Ext.util.JSON.decode(resp.responseText);
                        selectedUserId = data.UserId;
                        tree.root.reload();

                        //Ext.getCmp("UserId").setValue(data.UserId);
                        Ext.getCmp("UserName").setValue(data.UserName);
                        Ext.getCmp("UserRealname").setValue(data.UserRealname);
                        if (data.UserIslocked == 1 || data.UserIslocked == '1') {
                            Ext.getCmp("UserIslocked").dom.checked = true;
                        }
                        if (data.UserBindip == 1 || data.UserBindip == '1') {
                            Ext.getCmp("UserBindip").dom.checked = true
                        };
                        Ext.getCmp("UserIpaddress").setValue(data.UserIpaddress);


                    },
                    failure: function(resp, opts) {

                    }
                });
            }
            function saveUserData() {
                var strUSER_ISLOCKED = '0';
                //用户锁定
                if (Ext.get("UserIslocked").dom.checked) {
                    strUSER_ISLOCKED = "1";
                }
                //绑定ip
                var strUSER_BINDIP = '0';
                if (Ext.get("UserBindip").dom.checked) {
                    strUSER_BINDIP = "1"
                }
                var ids = getSelectNodes();
                var sm = Ext.getCmp('empGrid').getSelectionModel();
                //获取选择的数据信息
                var selectData = sm.getSelected();
                Ext.Msg.wait("正在保存……");
                Ext.Ajax.request({
                    url: 'frmAdmEmpList.aspx?method=saveuser',
                    method: 'POST',
                    params: {
                        UserIslocked: strUSER_ISLOCKED,
                        UserBindip: strUSER_BINDIP,
                        //UserId: Ext.getCmp('UserId').getValue(),
                        UserName: Ext.getCmp('UserName').getValue(),
                        UserRealname: Ext.getCmp('UserRealname').getValue(),
                        UserPassword: Ext.getCmp('UserPassword').getValue(),
                        UserIpaddress: Ext.getCmp('UserIpaddress').getValue(),
                        UserRoles: ids,
                        EmpId: selectData.data.EmpId
                    },
                    success: function(resp, opts) {
                        Ext.Msg.hide();
                        if (checkExtMessage(resp)) {
                            uploadUserWindow.hide();
                        }

                    }
         , failure: function(resp, opts) {
             Ext.Msg.hide();
             Ext.Msg.alert("提示", "保存失败");
         }
                });
            }
        })
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div id="toolbar">
    </div>
    <div id="searchForm"></div>
    <div id="advanceSearch"></div>
    <div id="empGrid"></div>
    <div id="searchGrid"></div>
    </form>
</body>
</html>
