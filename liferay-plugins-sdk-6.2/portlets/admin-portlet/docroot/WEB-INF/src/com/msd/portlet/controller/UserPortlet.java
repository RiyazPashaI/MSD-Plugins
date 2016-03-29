package com.msd.portlet.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.HttpServletRequest;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.Contact;
import com.liferay.portal.model.ListType;
import com.liferay.portal.model.ListTypeConstants;
import com.liferay.portal.model.Organization;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ListTypeServiceUtil;
import com.liferay.portal.service.OrganizationLocalServiceUtil;
import com.liferay.portal.service.PhoneLocalServiceUtil;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;
import com.msd.slayer.model.Customer;
import com.msd.slayer.model.UserDetails;
import com.msd.slayer.service.CustomerLocalServiceUtil;
import com.msd.slayer.service.UserDetailsLocalServiceUtil;
import com.msd.util.CommonUtil;

/**
 * Portlet implementation class UserPortlet
 */
public class UserPortlet extends MVCPortlet {
	
	private static final Log _log = LogFactoryUtil.getLog(UserPortlet.class);
	
	@Override
	public void serveResource(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) throws IOException,
			PortletException {
		_log.info("Inside serveResource method start");
		String resourceId = resourceRequest.getResourceID();
		
		if(resourceId.equalsIgnoreCase("getCustomers")){
			fetchCustomers(resourceRequest,resourceResponse);
		}
	}

	private void fetchCustomers(ResourceRequest resourceRequest,
			ResourceResponse resourceResponse) {
		
		List<Customer> alCustomer = null;
		JSONObject jsonObject = null;
		Organization org = null;
		PrintWriter writer = null;
		JSONArray jsonArray = JSONFactoryUtil.createJSONArray();
		
		HttpServletRequest httpReq = PortalUtil.getHttpServletRequest(resourceRequest);
		_log.info("Inside fetchCustomers() ... "+PortalUtil.getOriginalServletRequest(httpReq).getParameter("agentId"));
		
		long agentId = Long.parseLong(PortalUtil.getOriginalServletRequest(httpReq).getParameter("agentId"));		
		alCustomer = CustomerLocalServiceUtil.findByAgentId(agentId);
		
		if(Validator.isNotNull(alCustomer) && alCustomer.size() > 0) {
			for(Customer customer : alCustomer) {
				try {
					org = OrganizationLocalServiceUtil.fetchOrganization(customer.getCustomerId());
				} catch (SystemException e) {
					_log.error(e);
				}
				jsonObject = JSONFactoryUtil.createJSONObject();
				jsonObject.put(org.getName(), customer.getCustomerId());
				jsonArray.put(jsonObject);
			}
		}
		
		try {
			writer = resourceResponse.getWriter();
			writer.println(jsonArray);
		} catch (IOException e) {
			_log.error(e);
		}
		
		
	}
	public void updateUser(ActionRequest actionRequest,
			ActionResponse actionResponse) throws IOException, PortletException {
		
		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(WebKeys.THEME_DISPLAY);
		
		//Get user information
		String userName = ParamUtil.getString(actionRequest, "userName"); 
		String status = ParamUtil.getString(actionRequest, "status"); //?Need to make user deactivated?
		long companyId = ParamUtil.getLong(actionRequest, "companyId");  
		
		//Information related to Organization  user
		int salutation = ParamUtil.getInteger(actionRequest, "prefixId"); 
		String firstName = ParamUtil.getString(actionRequest, "firstName"); 
		String lastName = ParamUtil.getString(actionRequest, "lastName");  
		String email = ParamUtil.getString(actionRequest, "email");
		String emailStatus = ParamUtil.getString(actionRequest, "emailStatus");
		boolean callStatus = ParamUtil.getBoolean(actionRequest, "callStatus");
		String phoneNo = ParamUtil.getString(actionRequest, "phone"); 
		String mobileNo = ParamUtil.getString(actionRequest, "mobile"); 
		String otherPhoneNo = ParamUtil.getString(actionRequest, "otherPhone"); 
		String homePhone = ParamUtil.getString(actionRequest, "homePhone"); 
		String fax = ParamUtil.getString(actionRequest, "fax"); 
		
		boolean isBillingContact = ParamUtil.getBoolean(actionRequest, "isBilling");
		boolean isAvailable = ParamUtil.getBoolean(actionRequest, "isAvailable");
		String departmetn = ParamUtil.getString(actionRequest, "department");
		String title = ParamUtil.getString(actionRequest, "title");
		String functionalRole = ParamUtil.getString(actionRequest, "functionalRole");
		String secondaryEmail = ParamUtil.getString(actionRequest, "secondaryEmail");
		String emailReason = ParamUtil.getString(actionRequest, "secondaryEmail");
		String leadSource = ParamUtil.getString(actionRequest, "leadSource");
		String assistantName = ParamUtil.getString(actionRequest, "assistantName");
		String assistantPhone = ParamUtil.getString(actionRequest, "assistantPhone");
		String assistantEmail = ParamUtil.getString(actionRequest, "assistantEmail");
		
		String comments = ParamUtil.getString(actionRequest, "comments");
		
		ServiceContext serviceContext = new ServiceContext();
		serviceContext.setScopeGroupId(themeDisplay.getScopeGroupId());
		
		User user = null;
		long orgId[] =new long[]{ companyId };
		int phoneTypeId = 0;
		try {
			
			//Add user
			user = UserLocalServiceUtil.addUser(themeDisplay.getUserId(), themeDisplay.getCompanyId(),true, StringPool.BLANK, StringPool.BLANK, 
					false, userName,email,0l, StringPool.BLANK, themeDisplay.getLocale(),firstName,
					StringPool.BLANK ,lastName, salutation, 0, true, 0, 1, 1970,
					title, null,orgId , null, null, true, serviceContext);

			//Add phone numbers
			addPhoneDetails(Contact.class.getName() + ListTypeConstants.PHONE, 
					"Business", phoneNo, themeDisplay.getUserId(), 
					user.getUserId(), themeDisplay.getScopeGroupId());
			
			addPhoneDetails(Contact.class.getName() + ListTypeConstants.PHONE, 
					"mobile-phone", mobileNo, themeDisplay.getUserId(), 
					user.getUserId(), themeDisplay.getScopeGroupId());
			
			addPhoneDetails(Contact.class.getName() + ListTypeConstants.PHONE, 
					"Other", otherPhoneNo, themeDisplay.getUserId(), 
					user.getUserId(), themeDisplay.getScopeGroupId());
			
			addPhoneDetails(Contact.class.getName() + ListTypeConstants.PHONE, 
					"Personal", homePhone, themeDisplay.getUserId(), 
					user.getUserId(), themeDisplay.getScopeGroupId());
			addPhoneDetails(Contact.class.getName() + ListTypeConstants.PHONE, 
					"business-fax", fax, themeDisplay.getUserId(), 
					user.getUserId(), themeDisplay.getScopeGroupId());
			
			//Add details into custom table
			UserDetails userDetails  = UserDetailsLocalServiceUtil.addUser(user.getUserId(), user.getCompanyId(), assistantEmail, assistantName, assistantPhone, callStatus, departmetn,
					emailReason, emailStatus, functionalRole, isAvailable, isBillingContact, leadSource);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Add all phone numbers to the users
	 * @param listType 
	 * @param typeName
	 * @param phoneNumber
	 * @param userId
	 * @param classpk
	 * @param scopeGroupId
	 */
	private void addPhoneDetails(String listType, String typeName, String phoneNumber,long userId,long classpk,long scopeGroupId){
		
			ServiceContext serviceContext = new ServiceContext();
			serviceContext.setScopeGroupId(scopeGroupId);
			
			List<ListType> userPhoneType;
			int phoneTypeId =  0;
			try {
				userPhoneType = ListTypeServiceUtil.getListTypes(listType);
				CommonUtil.getListTypeId(userPhoneType, "Business");
			} catch (SystemException e) {
				_log.error(e);
			}
			
			try {
				PhoneLocalServiceUtil.addPhone(userId, User.class.getName(), 
						classpk, phoneNumber, "",phoneTypeId, true, serviceContext);
			} catch (Exception e) {
				_log.error(e);
			}
		
		
	}
}
