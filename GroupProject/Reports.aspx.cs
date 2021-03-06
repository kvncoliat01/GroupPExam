﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Serialization;
using System.Data;
using DAL_Project;
using System.IO;
using System.Data.SqlClient;
using System.Xml;
using System.Xml.Linq;
using Microsoft.Reporting.WebForms;



namespace GroupProject
{
    public partial class Reports : System.Web.UI.Page
    {
        DAL myDal = new DAL(Globals.conn);
        LoadBoxes LB = new LoadBoxes();
        protected XmlNamespaceManager ns;
        protected XmlDocument XmlDoc = new XmlDocument();
        string MatchCorrectAnswer;
        bool isCorrect = false;
        List<string> fillInCorrectAns = new List<string>();
        string TrueFalseCorrectAnswer;


        protected void Page_Load(object sender, EventArgs e)
        {
            Security mySecurity = new Security(2);

            // makes login panel on masterpage invisible
            Panel myPanel = (Panel)Master.FindControl("pnlLogin");
            myPanel.Visible = false;

            ReportViewer1.Visible = false;


            if (!IsPostBack)
            {
                loadCourse();
            }
        }

        private void loadCourse()
        {
            DataSet ds = LB.LoadCourse();
            ddlCourse.DataTextField = "Coursename";
            ddlCourse.DataValueField = "Courseid";
            ddlCourse.DataSource = ds;
            ddlCourse.DataBind();
            ddlCourse.Items.Insert(0, new ListItem("-Select Course-", String.Empty));
            ddlCourse.SelectedIndex = 0;
        }


        private void loadReports()
        {
            int SelectedReport = ddlReports.SelectedIndex;

            switch (SelectedReport)
            {
                case 0:

                    // Loads 'Issued Quizes' Report
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;

                    DataSet ds = new DataSet();
                    myDal.ClearParams();
                    ds = myDal.ExecuteProcedure("SD18EXAM_spGetIssuedQuizes");

                    if (ds.Tables[0].Rows.Count != 0)
                    {
                        lblMessage.Text = "";
                        gvIssuedQuizes.DataSource = ds.Tables[0];
                        gvIssuedQuizes.DataBind();
                        gvIssuedQuizes.Visible = true;
                        lblMessage.Text = "All Issued Quizes";

                    }
                    else
                    {
                        lblMessage.Text = "No Issued Quiz Data to Display!";
                        gvIssuedQuizes.Visible = false;
                    }

                    break;

                case 1:
                    // Loads 'Offline Quizes' Report
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;

                    lblMessage.Text = "";
                    DataSet ds2 = new DataSet();
                    myDal.ClearParams();
                    myDal.AddParam("@QuizStatus", 0);
                    ds2 = myDal.ExecuteProcedure("SD18EXAM_spGetQuizesByStatus");

                    if (ds2.Tables[0].Rows.Count != 0)
                    {
                        gvIssuedQuizes.DataSource = ds2.Tables[0];
                        gvIssuedQuizes.DataBind();
                        gvIssuedQuizes.Visible = true;
                        lblMessage.Text = "All Offline Quizes";
                    }
                    else
                    {
                        lblMessage.Text = "No Offline Quizes to Display!";
                        gvIssuedQuizes.Visible = false;
                    }

                    break;

                case 2:
                    // Loads 'Online Quizes' Report   
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;

                    lblMessage.Text = "";
                    myDal.ClearParams();
                    myDal.AddParam("@QuizStatus", 1);
                    ds = myDal.ExecuteProcedure("SD18EXAM_spGetQuizesByStatus");

                    if (ds.Tables[0].Rows.Count != 0)
                    {
                        gvIssuedQuizes.DataSource = ds.Tables[0];
                        gvIssuedQuizes.DataBind();
                        gvIssuedQuizes.Visible = true;
                        lblMessage.Text = "All Online Quizes";
                    }
                    else
                    {
                        lblMessage.Text = "No Online Quizes to Display!";
                        gvIssuedQuizes.Visible = false;
                    }
                    break;

                case 3:
                    // Loads 'Completed Quizes' Report  
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;

                    lblMessage.Text = "";
                    myDal.ClearParams();
                    myDal.AddParam("@QuizStatus", 2);
                    ds = myDal.ExecuteProcedure("SD18EXAM_spGetQuizesByStatus");

                    if (ds.Tables[0].Rows.Count != 0)
                    {
                        gvIssuedQuizes.DataSource = ds.Tables[0];
                        gvIssuedQuizes.DataBind();
                        gvIssuedQuizes.Visible = true;
                        lblMessage.Text = "All Completed Quizes";
                    }
                    else
                    {
                        lblMessage.Text = "No Completed Quizes to Display!";
                        gvIssuedQuizes.Visible = false;
                    }
                    break;

                case 4:
                    // Loads 'Studentwise Quiz Response Report' Report
                    lblMessage.Text = "";
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;

                    ReportViewer1.ProcessingMode = ProcessingMode.Local;
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Report1.rdlc");
                    ReportDataSource datasource = new ReportDataSource("dsStudentResponse", GetStudentResponseData());
                    ReportViewer1.LocalReport.DataSources.Clear();
                    ReportViewer1.LocalReport.DataSources.Add(datasource);
                    ReportViewer1.Visible = true;
                    lblMessage.Text = "Studentwise Quiz Response Report";

                    break;

                case 5:
                    // Loads 'Quiz Analysis'
                    lblMessage.Text = "";
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;

                    ReportViewer1.ProcessingMode = ProcessingMode.Local;
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Report2.rdlc");
                    ReportDataSource datasource2 = new ReportDataSource("dsQuizDetails", GetQuizDetailsData());
                    ReportViewer1.LocalReport.DataSources.Clear();
                    ReportViewer1.LocalReport.DataSources.Add(datasource2);
                    ReportViewer1.Visible = true;
                    lblMessage.Text = "Quiz Analysis";

                    break;

                case 6:
                    // View Student Responses
                    lblMessage.Text = "";
                    gvIssuedQuizes.Visible = false;
                    gvViewStudentResponse.Visible = false;
                    ReportViewer1.Visible = false;
                
                    DataSet dsStudentResponse = new DataSet();
                    myDal.ClearParams();
                    myDal.AddParam("@Classid", ddlClass.SelectedValue.ToString());
                    dsStudentResponse = myDal.ExecuteProcedure("SD18EXAM_spGetStudentResponseDetails");

                    if (dsStudentResponse.Tables[0].Rows.Count != 0)
                    {
                        lblMessage.Text = "";
                        gvViewStudentResponse.DataSource = dsStudentResponse.Tables[0];
                        gvViewStudentResponse.DataBind();
                        gvViewStudentResponse.Visible = true;
                        lblMessage.Text = "Student Response Data";

                    }
                    else
                    {
                        lblMessage.Text = "No Data to Display for selected !";
                        gvViewStudentResponse.Visible = false;
                    }


                    break;

                default:
                    break;
            }
        }

        public DataTable GetStudentResponseData()
        {
            myDal.ClearParams();          
            myDal.AddParam("@Classid", ddlClass.SelectedValue.ToString());
            myDal.AddParam("@Versionid", ddlVersion.SelectedValue.ToString());

            DataSet ds = new DataSet();

            ds = myDal.ExecuteProcedure("SD18EXAM_spGetStudentResponseReport");
            //return myDal.ExecuteProcedure("SD18EXAM_spGetStudentResponseReport").Tables[0];

            return ds.Tables[0];

        }

        public DataTable GetQuizDetailsData()
        {
            myDal.ClearParams();
            myDal.AddParam("@Versionid", ddlVersion.SelectedValue.ToString());
            return myDal.ExecuteProcedure("SD18EXAM_spGetQuizDetails").Tables[0];
        }

        protected void btnViewReport_Click(object sender, EventArgs e)
        {
            ReportViewer1.Visible = true;

            loadReports();
        }




        protected void btnPopUpClose_Click(object sender, EventArgs e)
        {
            MPE1.Hide();
        }

        protected void lbViewQuiz_Click(object sender, EventArgs e)
        {
            LinkButton linkUpdate = sender as LinkButton;
            GridViewRow grid = (GridViewRow)linkUpdate.NamingContainer;
            string tempID = gvIssuedQuizes.DataKeys[grid.RowIndex].Value.ToString();
            ViewState["tempId"] = tempID;

            RenderXML RX = new RenderXML();

            DataSet ds = RX.XMLContent(tempID);
            XmlDoc.LoadXml(ds.Tables[0].Rows[0]["XmlFile"].ToString());

            ns = new XmlNamespaceManager(XmlDoc.NameTable);
            ns.AddNamespace("ns", "urn:Question-Schema");
            string xpath = "/ns:Quiz";
            XmlNodeList QuizNode = XmlDoc.SelectNodes(xpath, ns);
            DLExamDemo.DataSource = QuizNode;
            DLExamDemo.DataBind();        
            DLExamDemoFillBlanks.DataSource = QuizNode;
            DLExamDemoFillBlanks.DataBind();
            DLExamDemoTrueFalse.DataSource = QuizNode;
            DLExamDemoTrueFalse.DataBind();      
            MPE1.Show();

        }



        protected void ddlReports_SelectedIndexChanged(object sender, EventArgs e)
        {

            switch (ddlReports.SelectedIndex)
            {
                case 0:
                    pnlCourse.Visible = false;
                    pnlClass.Visible = false;
                    pnlQuiz.Visible = false;
                    pnlVersion.Visible = false;
                    break;
                case 1:
                    pnlCourse.Visible = false;
                    pnlClass.Visible = false;
                    pnlQuiz.Visible = false;
                    pnlVersion.Visible = false;
                    break;
                case 2:
                    pnlCourse.Visible = false;
                    pnlClass.Visible = false;
                    pnlQuiz.Visible = false;
                    pnlVersion.Visible = false;
                    break;
                case 3:
                    pnlCourse.Visible = false;
                    pnlClass.Visible = false;
                    pnlQuiz.Visible = false;
                    pnlVersion.Visible = false;
                    break;
                case 4:
                    pnlCourse.Visible = true;
                    pnlClass.Visible = true;
                    pnlQuiz.Visible = true;
                    pnlVersion.Visible = true;
                    break;
                case 5:
                    pnlCourse.Visible = true;
                    pnlClass.Visible = true;
                    pnlQuiz.Visible = true;
                    pnlVersion.Visible = true;

                    break;
                case 6:
                    pnlClass.Visible = true;
                    pnlCourse.Visible = true;
                    pnlQuiz.Visible = false;
                    pnlVersion.Visible = false;
                    break;
                default:
                    break;
            }


        }

        protected void ddlCourse_SelectedIndexChanged(object sender, EventArgs e)
        {


            DataSet ds = LB.LoadClasses(ddlCourse.SelectedValue.ToString());
            ddlClass.DataTextField = "Classname";
            ddlClass.DataValueField = "Classid";
            ddlClass.DataSource = ds;
            ddlClass.DataBind();
            ddlClass.Items.Insert(0, new ListItem("-Select Class-", String.Empty));
            ddlClass.SelectedIndex = 0;

            // loads available quizes based on Course ID
            DataSet ds1 = LB.LoadQuizes(ddlCourse.SelectedValue.ToString());
            ddlQuiz.DataTextField = "Title";
            ddlQuiz.DataValueField = "XMLQuizID";
            ddlQuiz.DataSource = ds1;
            ddlQuiz.DataBind();
            ddlQuiz.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
            ddlQuiz.SelectedIndex = 0;

        }

        protected void ddlQuiz_SelectedIndexChanged(object sender, EventArgs e)
        {


            DataSet ds = LB.LoadQuizVersions(ddlQuiz.SelectedValue.ToString());
            ddlVersion.DataTextField = "Version";
            ddlVersion.DataValueField = "Versionid";
            ddlVersion.DataSource = ds;
            ddlVersion.DataBind();
            ddlVersion.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
            ddlVersion.SelectedIndex = 0;
        }

        protected void lbViewStudentResponse_Click(object sender, EventArgs e)
        {
            LinkButton linkUpdate = sender as LinkButton;
            GridViewRow grid = (GridViewRow)linkUpdate.NamingContainer;
            string tempID = gvViewStudentResponse.DataKeys[grid.RowIndex].Value.ToString();
            ViewState["tempId"] = tempID;

            RenderXML RX = new RenderXML();

            DataSet ds = RX.XMLContent2(tempID);
            XmlDoc.LoadXml(ds.Tables[0].Rows[0]["XMLStudentResponse"].ToString());

            ns = new XmlNamespaceManager(XmlDoc.NameTable);
            ns.AddNamespace("ns", "urn:Question-Schema");
            string xpath = "/ns:Quiz";
            XmlNodeList QuizNode = XmlDoc.SelectNodes(xpath, ns);
            DLViewResponseReport.DataSource = QuizNode;
            DLViewResponseReport.DataBind();
            DLViewResponseReportFillin.DataSource = QuizNode;
            DLViewResponseReportFillin.DataBind();
            DLViewResponseReportTrueFalse.DataSource = QuizNode;
            DLViewResponseReportTrueFalse.DataBind();

            MPE2.Show();

        }

        protected void btnClose2_Click(object sender, EventArgs e)
        {
            MPE2.Hide();
        }

        protected void rpt3_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MatchCorrectAnswer = "";
                MatchCorrectAnswer = ((Label)e.Item.FindControl("lblAnswer")).Text.ToString();
                // ((Label)e.Item.FindControl("lblAnswer")).Text = "<b>***Good***</b>";

            }
        }

        private void GreenORRed(RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (isCorrect)
                    ((Panel)e.Item.FindControl("pnlQuestion")).Style.Add(HtmlTextWriterStyle.BorderColor, "Green");
                else
                    ((Panel)e.Item.FindControl("pnlQuestion")).Style.Add(HtmlTextWriterStyle.BorderColor, "Red");
            }
            isCorrect = false;
        }
        protected void rptMultiple_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            GreenORRed(e);
        }

        protected void rptStudentAnswer_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string StudentAnswer = ((Label)e.Item.FindControl("lblStudentAnswer")).Text.ToString();
                if (StudentAnswer == MatchCorrectAnswer)
                    isCorrect = true;
            }
        }

        protected void rpt3Fill_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string CorrectAnswer = ((Label)e.Item.FindControl("lblFillCorrectAns")).Text.ToString();
                fillInCorrectAns.Add(CorrectAnswer);
            }
        }

        protected void rptFillInUserAns_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string UserAns = ((Label)e.Item.FindControl("lblFillInUserAns")).Text.ToString();
                if (fillInCorrectAns.Contains(UserAns))
                    isCorrect = true;
            }
        }

        protected void rptFillBlanks_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            GreenORRed(e);
        }

        protected void rptTrueFalseCorAns_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                TrueFalseCorrectAnswer = ((Label)e.Item.FindControl("lblTrueFalseCorrecAns")).Text.ToString();
            }
        }

        protected void rptTrueFalseUserAns_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string UserAnswer = ((Label)e.Item.FindControl("lblTrueFalseUserAns")).Text.ToString();
                if(TrueFalseCorrectAnswer == UserAnswer)
                    isCorrect = true;
            }
        }

        protected void rptTrueFalse_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                GreenORRed(e);
            }
        }

    }

}
