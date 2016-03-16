<%@page import="com.msd.util.AdminConstants"%>
<%@page import="com.liferay.portal.service.OrganizationLocalServiceUtil"%>
<%@include file="/html/common/init.jsp" %>

<table id="example" class="display" width="100%" cellspacing="0">
	<thead>
		<tr>
			<th><%=LanguageUtil.get(pageContext, "customer-id") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "agent-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-type") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-ppu") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-status") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-circulation") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-City") %></th>
			<th><%=LanguageUtil.get(pageContext, "setup-date") %></th>
			<th><%=LanguageUtil.get(pageContext, "termination-date") %></th>
		</tr>
	</thead>
	<tbody>
		<% 
			List<Customer> customerList = null;
			if (themeDisplay.getPermissionChecker().isOmniadmin())
				customerList = CustomerLocalServiceUtil.getCustomers(-1, -1); 
			else
				customerList = CustomerLocalServiceUtil.findByAgentId(themeDisplay.getCompanyId()); 
			for(Customer customer : customerList) {
				Organization organization = OrganizationLocalServiceUtil.fetchOrganization(customer.getCustomerId());
				Agent agent = AgentLocalServiceUtil.fetchAgent(customer.getAgentId());
				PortletURL viewCustomerDetailsURL = renderResponse.createRenderURL();
				viewCustomerDetailsURL.setParameter("jspPage", AdminConstants.PAGE_CUSTOMER_CREATE_JSP);
				viewCustomerDetailsURL.setParameter("customerId", String.valueOf(customer.getCustomerId()));
				viewCustomerDetailsURL.setParameter("tabs", "create");
				%>
					<tr>
						<th><%=customer.getUniqueId()%></th>
						<th>
							<a href="<%= viewCustomerDetailsURL.toString() %>"> 
								<%= Validator.isNotNull(organization)?organization.getName():"" %>
							</a>
						</th>
						<th><%=Validator.isNotNull(agent)?agent.getDisplayName():StringPool.BLANK%></th>
						<th></th>
						<th></th>
						<th><%=customer.getStatus()%></th>
						<th></th> 
						<th></th> 
						<th><%=CommonUtil.dateMonthYearFormat.format(customer.getCreateDate()) %></th> 
						<th></th> 
					</tr>
				<%
			}	
		%>
	</tbody>
</table>
<aui:script>
	$(document).ready(function() {
		$('#example').DataTable();
	});
</aui:script>