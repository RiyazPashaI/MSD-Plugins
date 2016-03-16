<%@page import="com.liferay.portal.service.OrganizationLocalServiceUtil"%>
<%@include file="/html/common/init.jsp" %>

<%@page import="com.msd.slayer.service.AgentLocalServiceUtil"%>
<%@page import="com.msd.slayer.model.Agent"%>


<portlet:actionURL name="updateUser" var="updateUser">
	<portlet:param name="tabs1" value='<%=ParamUtil.getString(request, "tabs1")%>'/>
</portlet:actionURL>
<portlet:resourceURL var = "getCustomersURL" id="getCustomers" />
<%
	String currSubTab = ParamUtil.getString(request, "currSubTab", "Details");
	List<Agent> alAgent = AgentLocalServiceUtil.getAgents(-1, -1);
	String parentTab = ParamUtil.getString(request, "tabs1", "Search");
	
	Organization org = null;
%>

<portlet:renderURL var="subTabsURL">
	<portlet:param name="currSubTab" value="<%= currSubTab %>" />
	
</portlet:renderURL>
<portlet:renderURL var="detailsTabsURL">
	<portlet:param name="jspPage" value="/html/user/detail.jsp" />
	<portlet:param name="currSubTab" value="<%= currSubTab %>" />
	<portlet:param name="tabs1" value="<%= parentTab %>" />
</portlet:renderURL>

<aui:form method="post" name="createform" action="<%=updateUser %>" inlineLabels="true" >
	<aui:layout>
		<aui:column columnWidth="50" >
			<aui:input name="userName" label="User Name"/>
			<aui:select name="agent" id="agent" onChange="getCustomers()">
				<aui:option value="-1" >Select Agent</aui:option>
				<%if(themeDisplay.getPermissionChecker().isOmniadmin()){
					for(Agent agent : alAgent) {
				%>	
					<aui:option value="<%=agent.getAgentId() %>"><%=agent.getDisplayName() %></aui:option>	
				<%	}
				}
				else{
					Agent objAgent = AgentLocalServiceUtil.fetchAgent(themeDisplay.getCompanyId());
				%>	
					<aui:option value="<%=objAgent.getAgentId() %>" selected="true"><%=objAgent.getDisplayName() %></aui:option>
				<%
					}
				%>
				
			</aui:select>
			
		</aui:column>
		<aui:column columnWidth="50" >
			<aui:select name="status">
				<aui:option value="N">No</aui:option>
				<aui:option value="Y">Yes</aui:option>
			</aui:select>
			<aui:select name="companyId" id="companyId"  label="Company Name">
				<aui:option value="-1" >Select Agent</aui:option>
				<%if(!themeDisplay.getPermissionChecker().isOmniadmin()){
					List<Customer> alCustomer = CustomerLocalServiceUtil.findByAgentId(themeDisplay.getCompanyId());
					for(Customer objCustomer : alCustomer){
						org = OrganizationLocalServiceUtil.fetchOrganization(objCustomer.getCustomerId());
				%>
					<aui:option value="<%=org.getOrganizationId() %>" ><%=org.getName() %></aui:option>
				<%	}
					
				}%>
				
			</aui:select>
			
		</aui:column>
	</aui:layout>
	
	<!-- Declare another tabs -->
	 <liferay-ui:tabs names="Details,Password Management,Permission Settings,Subscription,Invoices/Payements" url="<%=subTabsURL %>" param="currSubTab">
		<liferay-ui:section>
			<%@include file="/html/user/detail.jsp"%>	
		</liferay-ui:section>

	</liferay-ui:tabs> 
	
	<aui:button-row  cssClass="text-left">
		<aui:button type="submit" value="Add New User"/>	
       	<aui:button type="reset" value="Reset" />
	</aui:button-row>

</aui:form>

<script type="text/javascript">

function getCustomers(){
	var agentId = $("#<portlet:namespace/>agent").val();
	jQuery.ajax({
		dataType : 'json',
		type : 'get',
		data : {
			agentId : agentId
		},
		url : "<%= getCustomersURL%>",
		error: function(data){
   		},
   		success: function(data) {
			 var a = JSON.stringify(data);
			 $('#<portlet:namespace/>companyId').html('');
			 $('#<portlet:namespace/>companyId').append('<option value="-1" >----Select----</option>');
			 $.each(data,function(key,value){
				$.each(value,function(subKey,subValue){
					$('<option />', {value: subValue, text: subKey }).appendTo("#<portlet:namespace/>companyId");
				});
			});
   		}
	})
}

</script>