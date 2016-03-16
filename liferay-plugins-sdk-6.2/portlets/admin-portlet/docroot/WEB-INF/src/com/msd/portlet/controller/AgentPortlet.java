package com.msd.portlet.controller;

import java.io.IOException;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Company;
import com.liferay.portal.service.CompanyLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.msd.slayer.service.AgentLocalServiceUtil;

/**
 * Portlet implementation class AgentPortlet
 */
public class AgentPortlet extends MVCPortlet {

	public void createAgent(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {
		
		_log.info("Creating Agent . . .");
		
		ThemeDisplay themeDisplay = (ThemeDisplay) actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		String displayName = ParamUtil.getString(actionRequest, "display-name");
		String uniqueAgentName = ParamUtil.getString(actionRequest, "unique-agent-name");
		String agentGuestUser = ParamUtil.getString(actionRequest, "guest-user-name");
		String home = ParamUtil.getString(actionRequest, "default-homepage-action");
		String chatLink = ParamUtil.getString(actionRequest, "chat-url");
		String mainSearch = ParamUtil.getString(actionRequest, "main-search");
		String realm = ParamUtil.getString(actionRequest, "realm");
		String newRealm = ParamUtil.getString(actionRequest, "new-realm");
		String webId = ParamUtil.getString(actionRequest, "webId");
		String agentGuestPwd = ParamUtil.getString(actionRequest, "guest-password");
		String currencyType= ParamUtil.getString(actionRequest, "curency-symbol");
		String timezone = ParamUtil.getString(actionRequest, "timezone");
		String virtualHostname = ParamUtil.getString(actionRequest, "virtual-hostname");
		String billingQuestions = StringPool.BLANK;
		String wireTransferInfo = StringPool.BLANK;
		String paymentAddrDomestic = StringPool.BLANK;
		String paymentAddrForeign = StringPool.BLANK;
		String sellMediaDatabase = StringPool.BLANK;
		String mx = virtualHostname;
		String shardName = StringPool.BLANK;
		boolean enableRegWiz = ParamUtil.getBoolean(actionRequest, "enableRegWiz");
		boolean system = false;
		boolean active = true;
		long agentId = ParamUtil.getLong(actionRequest, "agentId");
		int maxUsers = 0;
		int downloadLimit = ParamUtil.getInteger(actionRequest, "download-limit");

		if (agentId == 0) {
			try {
				Company company = CompanyLocalServiceUtil.addCompany(webId,
						virtualHostname, mx, shardName, system, maxUsers, active);
				agentId = company.getCompanyId();
			} catch (PortalException e) {
				_log.error(e.getMessage());
			} catch (SystemException e) {
				_log.error(e.getMessage());
			}
		} else {
			try {
				CompanyLocalServiceUtil.updateCompany(
						agentId, virtualHostname, mx, maxUsers, active);
			} catch (PortalException e) {
				_log.error(e.getMessage());
			} catch (SystemException e) {
				_log.error(e.getMessage());
			}
		}

		AgentLocalServiceUtil.addAgent(agentId,
				themeDisplay.getScopeGroupId(), themeDisplay.getCompanyId(),
				themeDisplay.getUserId(), themeDisplay.getUser().getFullName(),
				themeDisplay.getUserId(), uniqueAgentName, displayName,
				newRealm, home, mainSearch, chatLink, currencyType,
				downloadLimit, agentGuestPwd, agentGuestUser, enableRegWiz,
				timezone, billingQuestions, wireTransferInfo,
				paymentAddrDomestic, paymentAddrForeign, sellMediaDatabase);
		actionResponse.setRenderParameter("agent-tabs", "create-new");
	}
	
	private final static Log _log = LogFactoryUtil.getLog(AgentPortlet.class);
}
