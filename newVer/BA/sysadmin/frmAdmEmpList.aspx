<%@ Page Language="C#" AutoEventWireup="true" validateRequest="false" CodeFile="frmAdmEmpList.aspx.cs" Inherits="BA_sysadmin_frmAdmEmpList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ա����Ϣ</title>
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
            /*------ʵ��toolbar�ĺ��� start---------------*/
            var Toolbar = new Ext.Toolbar({
                renderTo: 'toolbar',
                region: "north",
                height: 25,
                items: [{
                    text: "����",
                    icon: imageUrl + "images/extjs/customer/add16.gif",
                    handler: function() {
                        saveType = "add";
                        openAddEmployeeWin();
                        AddKeyDownEvent('divEmp');



                    }
                }, '-', {
                    text: "�༭",
                    icon: imageUrl + "images/extjs/customer/edit16.gif",
                    handler: function() {
                        saveType = "editemp";
                        modifyEmployeeWin();
                        AddKeyDownEvent('divEmp')
                    }
//                }, '-', {
//                    text: "ɾ��",
//                    icon: imageUrl + "images/extjs/customer/delete16.gif",
//                    handler: function() {
//                        deleteEmployee();
//                    }
                }, '-', {
                    text: "�����û�",
                    icon: imageUrl + "images/extjs/customer/delete16.gif",
                    handler: function() {
                        modifyUserWin();
                        //                        var sm = Ext.getCmp('empGrid').getSelectionModel();
                        //                        //��ȡѡ���������Ϣ
                        //                        var selectData = sm.getSelected();
                        //                        if (selectData == null) {
                        //                            Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����û���Ա����Ϣ��");
                        //                        return;
                        //                        }
                        //                        Ext.getCmp("UserRealname").setValue(selectData.data.EmpName);
                        //                        uploadUserWindow.show();
                    }
}]
                });

               
                /*------����toolbar�ĺ��� end---------------*/


                /*------��ʼToolBar�¼����� start---------------*//*-----����Employeeʵ���ര�庯��----*/
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
                /*-----�༭Employeeʵ���ര�庯��----*/
                function modifyEmployeeWin() {
                    var sm = Ext.getCmp('empGrid').getSelectionModel();
                    //��ȡѡ���������Ϣ
                    var selectData = sm.getSelected();
                    if (selectData == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�༭��Ա����Ϣ��");
                        return;
                    }
                    setFormValue(selectData);
                    uploadEmployeeWindow.show();

                }
                /*-----ɾ��Employeeʵ�庯��----*/
                /*ɾ����Ϣ*/
                function deleteEmployee() {
                    var sm = Ext.getCmp('empGrid').getSelectionModel();
                    //��ȡѡ���������Ϣ
                    var selectData = sm.getSelected();
                    //���û��ѡ�񣬾���ʾ��Ҫѡ��������Ϣ
                    if (selectData == null) {
                        Ext.Msg.alert("��ʾ", "��ѡ����Ҫɾ������Ϣ��");
                        return;
                    }
                    //ɾ��ǰ�ٴ������Ƿ����Ҫɾ��
                    Ext.Msg.confirm("��ʾ��Ϣ", "�Ƿ����Ҫɾ��ѡ���Ա����Ϣ��", function callBack(id) {
                        //�ж��Ƿ�ɾ������
                        if (id == "yes") {
                            //ҳ���ύ
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
                                    Ext.Msg.alert("��ʾ", "����ɾ��ʧ��");
                                }
                            });
                        }
                    });
                }

                /*------ʵ��FormPanle�ĺ��� start---------------*/
                var divEmp = new Ext.form.FormPanel({
                    frame: true,
                    title: '',
                    items: [
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 1,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '��ʶ',
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
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '���',
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
				    fieldLabel: '����',
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
				    fieldLabel: '�Ա�',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpSex',
				    id: 'EmpSex',
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '��ѡ���Ա���Ϣ',
				    triggerAction: 'all'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '��������',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpBirthday',
				    id: 'EmpBirthday',
				    format: "Y��m��d��"
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
				    fieldLabel: 'ѧ��',
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
				    fieldLabel: 'ѧλ',
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
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'datefield',
				    fieldLabel: '��ҵʱ��',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpGraduationdate',
				    id: 'EmpGraduationdate',
				    format: "Y��m��"
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
				    fieldLabel: 'רҵ',
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
				    fieldLabel: '������ò',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpPolitical',
				    id: 'EmpPolitical',
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '��ѡ��������ò��Ϣ',
				    triggerAction: 'all'
				}
		]
}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'combo',
				    fieldLabel: '����',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'DeptId',
				    id: 'DeptId',
				    store: DeptIdStore,
				    displayField: 'DeptName',
				    valueField: 'DeptId',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '��ѡ������Ϣ',
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
				    fieldLabel: '����ID',
				    //columnWidth: 0.67,
				    anchor: '90%',
				    name: 'OrgId',
				    id: 'OrgId'
				},
				{
				    xtype: 'textfield',
				    fieldLabel: '��������',
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
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'hidden',
				    fieldLabel: '��λ',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpJob',
				    id: 'EmpJob'
				}
				, {
				    xtype: 'textfield',
				    fieldLabel: '��λ',
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
				    fieldLabel: '��ְʱ��',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpJoindate',
				    id: 'EmpJoindate',
				    format: "Y��m��d��"
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
//				    fieldLabel: '����',
//				    columnWidth: 0.33,
//				    anchor: '90%',
//				    name: 'EmpBz',
//				    id: 'EmpBz',
//				    store: EmpBzStore,
//				    displayField: 'DicsName',
//				    valueField: 'OrderIndex',
//				    typeAhead: true,
//				    mode: 'local',
//				    emptyText: '��ѡ�������Ϣ',
//				    triggerAction: 'all'
//				}
//		]
//}
	]
	},
	{
	    layout: 'column',
	    border: false,
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'combo',
				    store: EmpStateStore,
				    fieldLabel: '��ְ״̬',
				    columnWidth: 0.33,
				    anchor: '90%',
				    name: 'EmpState',
				    id: 'EmpState',
				    displayField: 'DicsName',
				    valueField: 'OrderIndex',
				    typeAhead: true,
				    mode: 'local',
				    emptyText: '��ѡ����ְ״̬��Ϣ',
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
				    fieldLabel: '��ͥ��ַ',
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
	    labelSeparator: '��',
	    items: [
		{
		    layout: 'form',
		    border: false,
		    columnWidth: 0.33,
		    items: [
				{
				    xtype: 'textfield',
				    fieldLabel: '��ϵ�绰',
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
				    fieldLabel: '�ֻ�',
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
				    fieldLabel: '��ע',
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
                /*------FormPanle�ĺ������� End---------------*/
                Ext.getCmp("EmpJobName").on("focus", selectEmp);
                function selectEmp(v) {
                    if (selectPositionForm == null) {
                        showPositionForm(0, '��λѡ��', 'frmAdmEmpList.aspx?method=getpositiontreecolumnlist');
                        Ext.getCmp("btnOk").on("click", selectOK);
                    }
                    else {
                        showPositionForm(0, '��λѡ��', 'frmAdmEmpList.aspx?method=getpositiontreecolumnlist');
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


                //����������Ϣ
                function saveEmpData() {
                    getFormValue();
                }
                /*------��ʼ�������ݵĴ��� Start---------------*/
                if (typeof (uploadEmployeeWindow) == "undefined") {//�������2��windows����
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
		    text: "����"
			, handler: function() {
			    saveEmpData();
			}
			, scope: this
		},
		{
		    text: "ȡ��"
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

                /*------��ʼ��ȡ�������ݵĺ��� start---------------*/
                function getFormValue() {
                    Ext.MessageBox.wait("�������ڱ��棬���Ժ󡭡�");
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
                            Ext.Msg.alert("��ʾ", "����ʧ��");
                        }
                    });
                }
                /*------������ȡ�������ݵĺ��� End---------------*/

                /*------��ʼ�������ݵĺ��� Start---------------*/
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
                            Ext.Msg.alert("��ʾ", "��ȡ�û���Ϣʧ��");
                        }
                    });
                }
                /*------�������ý������ݵĺ��� End---------------*/

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
                /*------��ʼ��ȡ���ݵĺ��� start---------------*/
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
                /*------��ȡ���ݵĺ��� ���� End---------------*/

                var toolBar = new Ext.PagingToolbar({
                    pageSize: 10,
                    store: empGridData,
                    displayMsg: '��ʾ��{0}����{1}����¼,��{2}��',
                    emptyMsy: 'û�м�¼',
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
                    emptyText: '����ÿҳ��¼��',
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
                /*------��ʼDataGrid�ĺ��� start---------------*/

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
                    loadMask: { msg: '���ڼ������ݣ����Ժ��' },
                    sm: sm,
                    //cm: new Ext.grid.ColumnModel([sm,
                    columns: [sm,
                    rowNum, //�Զ��к�
                    {
                    header: '���',
                    dataIndex: 'EmpCode',
                    width: 100,
                    locked: true,
                    id: 'EmpCode',
                    locked: true
                },

		{
		    header: '��ʶ',
		    dataIndex: 'EmpId',
		    id: 'EmpId',
		    hidden: true
		},

		{
		    header: '����',
		    dataIndex: 'EmpName',
		    width: 100,
		    id: 'EmpName',
		    locked: true
		},
		{
		    header: '�Ա�',
		    dataIndex: 'EmpSex',
		    width: 100,
		    id: 'EmpSex',
		    renderer: getEmpSex
		},
		{
		    header: '��������',
		    dataIndex: 'EmpBirthday',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'EmpBirthday'
		},
		{
		    header: 'ѧ��',
		    dataIndex: 'EmpEducation',
		    width: 100,
		    id: 'EmpEducation'
		},
		{
		    header: 'ѧλ',
		    dataIndex: 'EmpDegree',
		    width: 100,
		    id: 'EmpDegree'
		},
		{
		    header: '��ҵʱ��',
		    dataIndex: 'EmpGraduationdate',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m'),
		    id: 'EmpGraduationdate'
		},
		{
		    header: 'רҵ',
		    dataIndex: 'EmpProfessional',
		    width: 100,
		    id: 'EmpProfessional'
		},
		{
		    header: '������ò',
		    dataIndex: 'EmpPolitical',
		    width: 100,
		    id: 'EmpPolitical'
		},
		{
		    header: '��λ',
		    dataIndex: 'EmpJob',
		    id: 'EmpJob'
		},
		{
		    header: '��ְʱ��',
		    dataIndex: 'EmpJoindate',
		    width: 100,
		    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		    id: 'EmpJoindate'
		},
		{
		    header: '��ְ״̬',
		    dataIndex: 'EmpState',
		    width: 100,
		    id: 'EmpState',
		    renderer: getEmpState
		},
		{
		    header: '��ͥ��ַ',
		    dataIndex: 'EmpAddress',
		    width: 100,
		    id: 'EmpAddress'
		},
		{
		    header: '��ϵ�绰',
		    dataIndex: 'EmpPhone',
		    id: 'EmpPhone'
		},
		{
		    header: '�ֻ�',
		    dataIndex: 'EmpMobil',
		    width: 100,
		    id: 'EmpMobil'
		},
		{
		    header: '��ע',
		    dataIndex: 'EmpMemo',
		    width: 100,
		    id: 'EmpMemo'
}],
                bbar: toolBar,
                viewConfig: {
                    columnsText: '��ʾ����',
                    scrollOffset: 20,
                    sortAscText: '����',
                    sortDescText: '����'

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
            /*------DataGrid�ĺ������� End---------------*/
            /*------ViewPort������---------------*/
            //                new Ext.Viewport({ layout: 'border', items: [
            //                    Toolbar, empGrid]
            //                })


            /*�����û���Ϣ*/
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
            fieldLabel: '�û���',
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
            fieldLabel: '��ʵ����',
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
                fieldLabel: '����',
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
            fieldLabel: '�Ƿ�����',
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
                fieldLabel: '�Ƿ��IP',
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
            fieldLabel: 'IP��ַ',
            anchor: '70%',
            id: 'UserIpaddress'}]
}]
}]
            });
            var selectedUserId = 0;
            /*���ɽ�ɫѡ���Tree����Ϣ******/
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
                text: '��ɫ��Ϣ',
                draggable: false,
                id: 'source'
            });
            tree.setRootNode(root);


            //��ȡѡ��Ľڵ���Ϣ
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

            //treeˢ��
            function treeReLoad(userID) {


            }
            /*****/

            if (typeof (uploadUserWindow) == "undefined") {//�������2��windows����
                uploadUserWindow = new Ext.Window({
                    id: 'userformwindow',
                    title: "�����û�"
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
                                                             text: "����"
		                                                    , handler: function() {
		                                                        //saveUserData();

		                                                        saveUserData();

		                                                    }
			                                                    , scope: this
                                                         },
	                                                    {
	                                                        text: "ȡ��"
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

            /*  �޸Ĵ���  */
            function modifyUserWin() {
                var sm = Ext.getCmp('empGrid').getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                if (selectData == null) {
                    Ext.Msg.alert("��ʾ", "��ѡ����Ҫ�����û���Ա����Ϣ��");
                    return;
                }
                uploadUserWindow.show();

                Ext.Ajax.request({
                    url: 'frmadmemplist.aspx?method=getuserbyempid',
                    params: {
                        EmpId: selectData.data.EmpId//�����û�seqId
                    },
                    success: function(resp, opts) {
                        //��û�д����û�
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
                //�û�����
                if (Ext.get("UserIslocked").dom.checked) {
                    strUSER_ISLOCKED = "1";
                }
                //��ip
                var strUSER_BINDIP = '0';
                if (Ext.get("UserBindip").dom.checked) {
                    strUSER_BINDIP = "1"
                }
                var ids = getSelectNodes();
                var sm = Ext.getCmp('empGrid').getSelectionModel();
                //��ȡѡ���������Ϣ
                var selectData = sm.getSelected();
                Ext.Msg.wait("���ڱ��桭��");
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
             Ext.Msg.alert("��ʾ", "����ʧ��");
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
