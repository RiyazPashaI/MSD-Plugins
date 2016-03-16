<%@include file="/html/common/init.jsp" %>

<portlet:actionURL name="createCustomer" var="createCustomer">
	<portlet:param name="tabs1" value='<%=ParamUtil.getString(request, "tabs1")%>'/>
</portlet:actionURL>

<portlet:renderURL var="backURL">
	<portlet:param name="jspPage" value="/html/customer/view.jsp"/> 
	<portlet:param name="tabs1" value='<%=ParamUtil.getString(request, "tabs1")%>'/>
</portlet:renderURL>

<%
	String currSubTab = ParamUtil.getString(request, "currSubTab", "Details");
	List<Agent> alAgent = AgentLocalServiceUtil.getAgents(-1, -1);
	String parentTab = ParamUtil.getString(request, "tabs1", "Search");
	
	long companyId = 0l;
	long customerId = ParamUtil.getLong(request, "customerId");

	String companyName = StringPool.BLANK;
	String parentCompany = StringPool.BLANK;
	String comment = StringPool.BLANK;
	String cmd = StringPool.BLANK;
	
	User _user = null;
	Customer customer = null;
	Organization organization = null;
	if (customerId > 0) {
		try {
			customer = CustomerLocalServiceUtil.fetchCustomer(customerId);
			organization = CommonUtil.getOrganization(customerId);
			if (Validator.isNotNull(customer)) {
				Company _company = CompanyLocalServiceUtil.fetchCompany(customer.getAgentId());
				parentCompany = customer.getParentCompany();
				comment = customer.getComment();
				companyId = _company.getCompanyId();
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		cmd = Constants.UPDATE;
	} else {
		cmd = Constants.ADD;
	}
	
	companyName = (Validator.isNotNull(organization)) ? organization.getName() :StringPool.BLANK;
%>

<portlet:renderURL var="subTabsURL">
	<portlet:param name="currSubTab" value="<%= currSubTab %>" />
</portlet:renderURL>

<portlet:renderURL var="detailsTabsURL">
	<portlet:param name="jspPage" value="/html/customer/detail.jsp" />
	<portlet:param name="currSubTab" value="<%= currSubTab %>" />
	<portlet:param name="tabs1" value="<%= parentTab %>" />
</portlet:renderURL>

<aui:form method="post" name="createform" action="<%= createCustomer %>" inlineLabels="true" >

	<aui:layout>
		<aui:column columnWidth="50" >
			<aui:input name="customerId" type="hidden" value="<%= customerId %>"/>
			<aui:input name="cmd" type="hidden" value="<%= cmd %>"/>
			<aui:input name="uniquecustomerId" label="Unique Customer Id" value="<%= (Validator.isNotNull(customer) ? customer.getUniqueId() : 0) %>"/>
			<aui:input name="companyName" label="Company Name" value="<%= companyName %>"/>
		</aui:column>
		<aui:column columnWidth="50" >
			<aui:select name="status">
				<aui:option value="N" label="No" selected='<%= (Validator.isNotNull(customer) && customer.getStatus().equals("N")) %>'/>
				<aui:option value="Y" label="Yes" selected='<%= (Validator.isNotNull(customer) && customer.getStatus().equals("Y"))  %>'/>
			</aui:select>
			<aui:select name="agent" >
				<aui:option value="-1">Select Agent</aui:option>
				<%
				if (themeDisplay.getPermissionChecker().isOmniadmin()) { 
					for (Agent agent : alAgent) {
						boolean selectedAgent = (Validator.isNotNull(customer) && (customer.getAgentId() == agent.getAgentId()));
						%>	<aui:option value="<%=agent.getAgentId() %>" selected="<%= selectedAgent %>"><%=agent.getDisplayName() %></aui:option><%	
					}
				} else {
					Agent agent = AgentLocalServiceUtil.fetchAgent(themeDisplay.getCompanyId());
					%><aui:option value="<%= agent.getAgentId() %>" selected="true"><%= agent.getDisplayName() %></aui:option><% 
				} 
				%>
			</aui:select>
		</aui:column>
	</aui:layout>
	
	<!-- Declare another tabs -->
	 <liferay-ui:tabs names="Details,Permission,Subscriptions" url="<%=subTabsURL %>" param="currSubTab">
		<liferay-ui:section>
			<%@include file="/html/customer/detail.jsp"%>	
		</liferay-ui:section>

		<liferay-ui:section>
			<%@include file="/html/customer/detail.jsp"%>
		</liferay-ui:section>
		<liferay-ui:section>
			<%@include file="/html/customer/detail.jsp"%>
		</liferay-ui:section>
	</liferay-ui:tabs> 
	
	<aui:button-row  cssClass="text-left">
		<c:choose>
			<c:when test='<%= (Validator.isNull(customer) || customerId == 0) %>'> 
				<aui:button type="submit" value="Add New Customer"/>
				<aui:button type="reset" value="Reset" />	
			</c:when>
			<c:otherwise>
				<aui:button type="submit" value="Update Customer"/>
				<aui:button type="button" value="Cancel" href="<%= backURL %>"/>
			</c:otherwise> 
		</c:choose>
	</aui:button-row>

</aui:form>