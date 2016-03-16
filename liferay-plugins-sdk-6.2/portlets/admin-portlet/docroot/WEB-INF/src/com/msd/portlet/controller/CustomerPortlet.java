package com.msd.portlet.controller;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.HttpServletRequest;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Contact;
import com.liferay.portal.model.ListType;
import com.liferay.portal.model.ListTypeConstants;
import com.liferay.portal.model.Organization;
import com.liferay.portal.model.Region;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ListTypeServiceUtil;
import com.liferay.portal.service.RegionServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.msd.slayer.service.CustomerLocalServiceUtil;
import com.msd.util.CommonUtil;

/**
 * Portlet implementation class CustomerPortlet
 */
public class CustomerPortlet extends MVCPortlet {

	private static final Log _log = LogFactoryUtil.getLog(CustomerPortlet.class);
	
	public void serveResource(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws IOException,
			PortletException {
		
		String cmd = ParamUtil.getString(resourceRequest, Constants.CMD);
		
		if(cmd.equalsIgnoreCase("getState")) {
			getState(resourceRequest,resourceResponse);
		}
	}
	
	public void createCustomer(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {

		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);

		//Information related to organization
		String cmd = ParamUtil.getString(actionRequest, "cmd");
		String uniqueId = ParamUtil.getString(actionRequest, "uniquecustomerId");
		String orgName =  ParamUtil.getString(actionRequest, "companyName"); 
		String status = ParamUtil.getString(actionRequest, "status"); 
		long agentId = ParamUtil.getLong(actionRequest, "agent"); 

		//Information related to Organization admin user
		long websiteId =  ParamUtil.getLong(actionRequest, "websiteId");
		long organizationId = ParamUtil.getLong(actionRequest, "organizationId");
		String parentCompany = ParamUtil.getString(actionRequest, "parentCompany");
		long salesPerson =  ParamUtil.getLong(actionRequest, "salesPerson"); 
		String tollfreeNo =  ParamUtil.getString(actionRequest, "companyNumber"); 
		String companyWebsite =  ParamUtil.getString(actionRequest, "companyWebsite"); 

		int salutation = ParamUtil.getInteger(actionRequest, "prefixId"); 
		long userId = ParamUtil.getLong(actionRequest, "userId");
		String firstName = ParamUtil.getString(actionRequest, "firstName"); 
		String lastName = ParamUtil.getString(actionRequest, "lastName");  
		String phoneNo = ParamUtil.getString(actionRequest, "phone"); 
		String title = ParamUtil.getString(actionRequest, "title"); 
		String email = ParamUtil.getString(actionRequest, "email");
		String fax = ParamUtil.getString(actionRequest, "fax"); 
		String comments = ParamUtil.getString(actionRequest, "comments");

		//Address
		String addr1 = ParamUtil.getString(actionRequest, "address");
		String addr2 = ParamUtil.getString(actionRequest, "address2");
		String city = ParamUtil.getString(actionRequest, "city"); 
		String postcode = ParamUtil.getString(actionRequest, "postcode"); 
		long countryId = ParamUtil.getLong(actionRequest, "countryId"); 
		long regionId = ParamUtil.getLong(actionRequest, "regionId"); 
		long addressId = ParamUtil.getLong(actionRequest, "addressId"); 
		long phoneNumId = ParamUtil.getLong(actionRequest, "phoneNumId");
		long phonefaxId = ParamUtil.getLong(actionRequest, "phonefaxId");
		long phonetollfreeId = ParamUtil.getLong(actionRequest, "phonetollfreeId");

		/* Add / update func*/
		ServiceContext serviceContext = new ServiceContext();
		serviceContext.setScopeGroupId(themeDisplay.getScopeGroupId());

		// Create Organization
		Organization organization = CommonUtil.addOrganization(organizationId, agentId, websiteId, 
				themeDisplay, orgName, companyWebsite, comments, cmd, serviceContext);

		//Add tollfree phone number
		try {
			List<ListType> orgPhoneTypes = ListTypeServiceUtil.getListTypes(Organization.class.getName()+ ListTypeConstants.PHONE);
			int tollFreePhoneTypeId = CommonUtil.getListTypeId(orgPhoneTypes, "toll-free");
			CommonUtil.addUpdatePhone(tollFreePhoneTypeId, themeDisplay.getUserId(), organization.getOrganizationId(),
					phonetollfreeId, tollfreeNo, Organization.class.getName(), cmd, serviceContext);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//Add orgAdmin user
		User user = null;
		long orgId[] = new long[]{ organization.getOrganizationId() };

		try {
			user = CommonUtil.addUpdateUser(salutation, userId, themeDisplay.getUserId(), agentId, firstName, lastName, title, email, cmd,
					orgId, serviceContext, themeDisplay.getLocale());

			List<ListType> addressType = ListTypeServiceUtil.getListTypes(Contact.class.getName() + ListTypeConstants.ADDRESS);
			int typeId =  CommonUtil.getListTypeId(addressType, "Other");
			CommonUtil.addUpdatePhone(typeId, themeDisplay.getUserId(), user.getUserId(), phoneNumId, phoneNo, User.class.getName(), cmd, serviceContext); 
			
			List<ListType> userPhoneType = ListTypeServiceUtil.getListTypes(Contact.class.getName() + ListTypeConstants.PHONE);
			int faxTypeId =  CommonUtil.getListTypeId(userPhoneType, "business-fax");
			CommonUtil.addUpdatePhone(faxTypeId, themeDisplay.getUserId(), user.getUserId(), phonefaxId, fax , User.class.getName(), cmd, serviceContext); 

			// Add / Update address
			CommonUtil.addUpdateAddress(faxTypeId, themeDisplay.getUserId(), user.getUserId(), countryId, regionId, addressId,
					addr1, addr2, city, postcode, cmd, serviceContext);
		} catch (Exception e) {
			e.printStackTrace();
		}

		//Add orgadmin role
		CommonUtil.assignOrganizationAdminRole(organization, cmd, user);

		// Add /Update customer
		try {
			CustomerLocalServiceUtil.updateCustomer(organization.getOrganizationId(), status, uniqueId, 
				agentId, parentCompany, salesPerson, comments, organization.getGroupId(), organization.getCompanyId(), 
				themeDisplay.getUserId(), new Date(), themeDisplay.getUserId(), new Date(), cmd);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * @param resourceRequest
	 * @param resourceResponse
	 */
	private void getState(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) {
		_log.info("getState");
		
		HttpServletRequest httpReq = PortalUtil.getHttpServletRequest(resourceRequest);
		long countryId = Long.parseLong(PortalUtil.getOriginalServletRequest(httpReq).getParameter("countryId"));
		
		_log.info("countryId :"+countryId);
		
		List<Region> regions = new ArrayList<Region>();
		JSONObject jsonObject = null;
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		
		try {
			regions = RegionServiceUtil.getRegions(countryId);
		} catch (SystemException e) {
			e.printStackTrace();
		}
		if(Validator.isNotNull(regions) && regions.size() > 0) {
			for(Region region : regions) {
				jsonObject = JSONFactoryUtil.createJSONObject();
				jsonObject.put("value", region.getRegionId());
				jsonObject.put("label", region.getName());
				jsonArray.put(jsonObject);
			}
		}
		
		PrintWriter writer = null;
		try {
			writer = resourceResponse.getWriter();
			writer.println(jsonArray);
		} catch (IOException e) {
			_log.error(e);
		}
		
	}
	
}
