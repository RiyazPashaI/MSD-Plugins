<%@include file="/html/common/init.jsp" %>

<%@page import="com.msd.slayer.model.Customer"%>
<%@page import="com.msd.slayer.service.CustomerLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Organization"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.msd.slayer.model.UserDetails"%>
<%@page import="com.msd.slayer.service.UserDetailsLocalServiceUtil"%>
<%@page import="com.msd.util.AdminConstants"%>
<%@page import="com.msd.slayer.service.AgentLocalServiceUtil"%>
<%@page import="com.msd.slayer.model.Agent"%>

<table id="example" class="display" width="100%" cellspacing="0">
	<thead>
		<tr>
			<th><%=LanguageUtil.get(pageContext, "user-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "first-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "last-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "user-email") %></th>
			<th><%=LanguageUtil.get(pageContext, "company-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "customer-id") %></th>
			<th><%=LanguageUtil.get(pageContext, "agent-name") %></th>
		</tr>
	</thead>
	<tbody>
		<% 
			List<UserDetails> userList = null;
			if(themeDisplay.getPermissionChecker().isOmniadmin())
			 	userList = UserDetailsLocalServiceUtil.getUserDetailses(-1, -1); 
			else
				userList = UserDetailsLocalServiceUtil.findByCompanyId(themeDisplay.getCompanyId());
			for(UserDetails userDetails : userList) {
				User objUser = UserLocalServiceUtil.getUser(userDetails.getUserId());
				PortletURL viewUserDetailsURL = renderResponse.createRenderURL();
				viewUserDetailsURL.setParameter("jspPage", "/html/user/createuser.jsp");
				List<Organization> organizationList =  objUser.getOrganizations();
				Organization org = null;
				Customer customer = null;
				Agent agent = null;
				if(Validator.isNotNull(organizationList) && organizationList.size()>0){
					 org = organizationList.get(0);
					 customer = CustomerLocalServiceUtil.fetchCustomer(org.getOrganizationId());
					 agent = AgentLocalServiceUtil.fetchAgent(customer.getAgentId());
				}
				%>
					<tr>
						
						<th>
							<%-- <a href="<%=viewUserDetailsURL.toString()%>"> --%>
								<%=Validator.isNotNull(objUser)?objUser.getScreenName():StringPool.BLANK %>
							<!-- </a> -->
						</th>
						<th><%=Validator.isNotNull(objUser)?objUser.getFirstName():StringPool.BLANK %></th>
						<th><%=Validator.isNotNull(objUser)?objUser.getLastName():StringPool.BLANK %></th>
						<th><%=Validator.isNotNull(objUser)?objUser.getEmailAddress():StringPool.BLANK %></th>
						<th><%=Validator.isNotNull(org)?org.getName():StringPool.BLANK%></th>
						<th><%=customer.getUniqueId()%></th>
						<th><%=Validator.isNotNull(agent)?agent.getDisplayName():StringPool.BLANK%></th>
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

