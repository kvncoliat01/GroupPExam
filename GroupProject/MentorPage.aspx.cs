﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using DAL_Project;

namespace GroupProject
{
    public partial class MentorPage : System.Web.UI.Page
    {
        DAL myDal = new DAL(Globals.conn);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadClass();
                loadQuiz();
                loadVersion();
                loadStudents();
                ViewQuiz();
            }
        }
        public void loadClass()
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            ds = myDal.ExecuteProcedure("spLoadClass");

            //Binds to the dropdownlist
            ddlClass.DataTextField = "Classname";
            ddlClass.DataValueField = "Classid";
            ddlClass.DataSource = ds;
            ddlClass.DataBind();
            ddlClass.Items.Insert(0, new ListItem("-Select Class-", String.Empty));
            ddlClass.SelectedIndex = 0;


        }

        public void loadQuiz()
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            ds = myDal.ExecuteProcedure("spLoadQuiz");

            ddlSelectQuiz.DataTextField = "QuizTitle";
            ddlSelectQuiz.DataValueField = "Quizid";
            ddlSelectQuiz.DataSource = ds;
            ddlSelectQuiz.DataBind();
            ddlSelectQuiz.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
            ddlSelectQuiz.SelectedIndex = 0;
        }
        public void loadVersion()
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            ds = myDal.ExecuteProcedure("spLoadVersion");

            //Binds to the dropdownlist
            ddlVersion.DataTextField = "Version";
            ddlVersion.DataValueField = "Versionid";
            ddlVersion.DataSource = ds;
            ddlVersion.DataBind();
            ddlVersion.Items.Insert(0, new ListItem("-Select Version", String.Empty));
            ddlVersion.SelectedIndex = 0;
        }

        protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            myDal.AddParam("Classid", ddlClass.SelectedValue.ToString());
            ds = myDal.ExecuteProcedure("spLoadCourse");

            lbCourseid.Text = ds.Tables[0].Rows[0]["Courseid"].ToString();


            DataSet ds2 = new DataSet();
            myDal.ClearParams();
            myDal.AddParam("Courseid", lbCourseid.Text);
            ds2 = myDal.ExecuteProcedure("spLoadQuiz2");

            ddlSelectQuiz.DataTextField = "QuizTitle";
            ddlSelectQuiz.DataValueField = "Quizid";
            ddlSelectQuiz.DataSource = ds2;
            ddlSelectQuiz.DataBind();
            ddlSelectQuiz.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
            ddlSelectQuiz.SelectedIndex = 0;

            DataSet ds3 = new DataSet();
            myDal.ClearParams();
            myDal.AddParam("Classid", ddlClass.SelectedValue.ToString());
            myDal.AddParam("SecurityLevel", "1");
            ds3 = myDal.ExecuteProcedure("spGetStudents3");

            cblStudents.DataTextField = "Studentname";
            cblStudents.DataValueField = "Userid";
            cblStudents.DataSource = ds3;
            cblStudents.DataBind();



        }
        public void loadStudents()
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            myDal.AddParam("SecurityLevel", "1");
            ds = myDal.ExecuteProcedure("spGetStudents2");

            cblStudents.DataTextField = "Studentname";
            cblStudents.DataValueField = "Userid";
            cblStudents.DataSource = ds;
            cblStudents.DataBind();

        }

        public void ViewQuiz()
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            ds = myDal.ExecuteProcedure("spViewQuiz");

            
            gvViewQuiz.DataSource = ds;
            gvViewQuiz.DataBind();
        }

        protected void btnIssueQuiz_Click(object sender, EventArgs e)
        {
            pnlIssueQuiz.Visible = true;
            pnlUploadQuiz.Visible = false;
            gvViewQuiz.Visible = false;
        }

        protected void btnUploadQuiz_Click(object sender, EventArgs e)
        {
            //Response.Redirect("MentorPage.aspx");
            pnlUploadQuiz.Visible = true;
            pnlIssueQuiz.Visible = false;
            gvViewQuiz.Visible = false;
        }

        protected void btnViewQuiz_Click(object sender, EventArgs e)
        {
            gvViewQuiz.Visible = true;
            pnlIssueQuiz.Visible = false;
            pnlUploadQuiz.Visible = false;
            
        }

  
    }
}