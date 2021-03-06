﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using DAL_Project;




namespace GroupProject
{
    public class Security
    {// From the table User
        int SecurityLevel;
        int Userid;
        public string Firstname;

        public Security()
        {//class using//method for security
            if (HttpContext.Current.Session["SecurityLevel"] != null)
            {
                SecurityLevel = (int)HttpContext.Current.Session["SecurityLevel"];
                Userid = (int)HttpContext.Current.Session["Userid"];
                Firstname = HttpContext.Current.Session["Firstname"].ToString();
            }
            else
            {
                SecurityLevel = 0;
                Firstname = "";
            }

        }
        //Checks and changing the url (SESSION)
        public Security(int PageSecurityLevel):this()
        {
            if (PageSecurityLevel>SecurityLevel) // Tests the Securitylevel
            {
                HttpContext.Current.Session.Abandon(); //Cancels the Session
                HttpContext.Current.Response.Redirect("Home.aspx"); //Redirect into the Homepage
            }
        }
        //Load the login Procedure to get the UserName and Password (SESSION)
        public Security (string Email, String Password)
        {
            DataSet ds = new DataSet();
            //Globals con = new Globals();
            DAL myDal = new DAL(Globals.conn);
            myDal.ClearParams();
            myDal.AddParam("@Email", Email);
            myDal.AddParam("@Password", Password);
            ds = myDal.ExecuteProcedure("SD18EXAM_spLogin");

            if(ds.Tables[0].Rows.Count ==0)
            {
                SecurityLevel = 0;
                Firstname = "Invalid Login";
                Userid = -1;

            }
            else
            {
                SecurityLevel = Convert.ToInt32(ds.Tables[0].Rows[0]["SecurityLevel"].ToString());
                Firstname = "Welcome " + ds.Tables[0].Rows[0]["FirstName"].ToString() + "!";
                Userid = Convert.ToInt32(ds.Tables[0].Rows[0]["Userid"].ToString());
            }
            HttpContext.Current.Session["Firstname"] = Firstname;
            HttpContext.Current.Session["SecurityLevel"] = SecurityLevel;
            HttpContext.Current.Session["Userid"] = Userid;
        }
        //returns the value of the security Level
        public int GetSecurityLevel()
        {
            return SecurityLevel;
        }
        //returns the value of the Userid
        public string GetId()
        {
            return Userid.ToString();
        }
    }
}