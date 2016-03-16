<%@page import="com.msd.util.AdminConstants"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="com.msd.slayer.service.AgentLocalServiceUtil"%>
<%@page import="com.msd.slayer.model.Agent"%>
<%@ include file="/html/common/init.jsp"%>

<table id="example" class="display" width="100%" cellspacing="0">
	<thead>
		<tr>
			<th><%=LanguageUtil.get(pageContext, "agent-id") %></th>
			<th><%=LanguageUtil.get(pageContext, "agent-name") %></th>
			<th><%=LanguageUtil.get(pageContext, "guest-user") %></th>
			<th><%=LanguageUtil.get(pageContext, "realm") %></th>
			<th><%=LanguageUtil.get(pageContext, "reg-wizard") %></th>
		</tr>
	</thead>
	<tbody>
		<% 
			List<Agent> agentList = AgentLocalServiceUtil.getAgents(-1, -1); 
			for(Agent agent : agentList) {
				PortletURL viewAgentDetailsURL = renderResponse.createRenderURL();
				viewAgentDetailsURL.setParameter("jspPage", AdminConstants.PAGE_AGENT_VIEW_JSP);
				viewAgentDetailsURL.setParameter("agentId", String.valueOf(agent.getAgentId()));
				viewAgentDetailsURL.setParameter("agent-tabs", "create-new");
				%>
					<tr>
						<th>
							<a href="<%=viewAgentDetailsURL.toString()%>">
								<%=agent.getAgentName() %>
							</a>
						</th>
						<th><%=agent.getDisplayName()%></th>
						<th><%=agent.getAgentGuestUser()%></th>
						<th><%=agent.getRealm()%></th>
						<th><%=agent.getEnableRegWiz()%></th>
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