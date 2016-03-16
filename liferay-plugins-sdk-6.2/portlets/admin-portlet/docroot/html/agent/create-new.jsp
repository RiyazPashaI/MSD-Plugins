<%@page import="com.liferay.portal.service.CompanyLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Company"%>
<%@page import="com.msd.slayer.service.AgentLocalServiceUtil"%>
<%@page import="com.msd.slayer.model.Agent"%>
<%@ include file="/html/common/init.jsp"%>
<liferay-ui:header title="new-agent"/>
<portlet:actionURL var="createAgentURL" name="createAgent"/>
<%
	String webId = StringPool.BLANK;
	String displayName = StringPool.BLANK;
	String uniqueAgentName = StringPool.BLANK;
	String guestUserName = StringPool.BLANK;
	String downloadLimit = StringPool.BLANK;
	String defaultHomepageAction = StringPool.BLANK;
	String chatUrl = StringPool.BLANK;
	String mainSearch = StringPool.BLANK;
	String virtualHostname = StringPool.BLANK;
	String realm = StringPool.BLANK;
	String guestPassword = StringPool.BLANK;
	String curencySymbol = StringPool.BLANK;
	String timezone = StringPool.BLANK;
	boolean enableRegistration = false;
	long agentId = ParamUtil.getLong(request, "agentId");
	Agent agent = AgentLocalServiceUtil.fetchAgent(agentId);
	if (Validator.isNotNull(agent)) {
		Company cmp = CompanyLocalServiceUtil.fetchCompany(agentId);
		webId = cmp.getWebId();
		virtualHostname = cmp.getVirtualHostname();
		displayName = agent.getDisplayName();
		uniqueAgentName = agent.getAgentName();
		guestUserName = agent.getAgentGuestUser();
		downloadLimit = String.valueOf(agent.getDownloadLimit());
		defaultHomepageAction = agent.getHome();
		chatUrl = agent.getChatLink();
		mainSearch = agent.getMainSearch();
		realm = agent.getRealm();
		guestPassword = agent.getAgentGuestPwd();
		curencySymbol = agent.getCurrencyType();
		timezone = agent.getTimezone();
		enableRegistration = agent.getEnableRegWiz();
	}
%>
<aui:form action="${createAgentURL}" inlineLabels="true">
	<aui:fieldset>
		<aui:col span="6" >
			<aui:input name="agentId" type="hidden" value="<%=agentId%>"/>
			<aui:input name="webId" required="true" value="<%=webId %>"/>
			<aui:input name="display-name" value="<%=displayName %>"/>
			<aui:input name="unique-agent-name" required="true" value="<%=uniqueAgentName %>"/>
			<aui:input name="guest-user-name" value="<%=guestUserName %>"/>
			<aui:input name="download-limit" value="<%=downloadLimit %>"/>
			<aui:input name="default-homepage-action" value="<%=defaultHomepageAction %>"/>
			<aui:input name="chat-url" value="<%=chatUrl %>"/>
			<aui:input name="main-search" type="textarea" value="<%=mainSearch %>"/>
		</aui:col>
		<aui:col span="6">
			<aui:input name="virtual-hostname" required="true" value="<%=virtualHostname %>"/>
			<aui:select name="realm" >
				<aui:option label="realm" value="realm"/>
			</aui:select>
			<aui:input name="new-realm" value="<%=realm %>"/>
			<aui:input name="enable-registration" type="checkbox" value="<%=enableRegistration %>"/>
			<aui:input name="guest-password" value="<%=guestPassword %>"/>
			<aui:input name="curency-symbol" value="<%=curencySymbol %>"/>
			<label class="control-label"><%=LanguageUtil.get(locale, "Timezone") %></label>
			<liferay-ui:input-time-zone name="timezone" displayStyle="1" value="<%=timezone %>"/>
		</aui:col>
		<aui:button-row>
			<aui:button type="submit" value='<%=(agentId > 0)? LanguageUtil.get(pageContext, "update") :LanguageUtil.get(pageContext, "create") %>'/>
		</aui:button-row>
	</aui:fieldset>
</aui:form>