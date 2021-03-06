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


namespace GroupProject
{
    public partial class MentorPage : System.Web.UI.Page
    {
        DAL myDal = new DAL(Globals.conn);
        LoadBoxes LB = new LoadBoxes();
        protected XmlNamespaceManager ns;
        protected XmlDocument XmlDoc = new XmlDocument();

        protected void Page_Load(object sender, EventArgs e)
        {
             Security mySecurity = new Security(2);

            if (!IsPostBack)
            {
                loadCourse();
                loadStatus();
                
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

        private void loadStatus()
        {
            //load statuses
            myDal.ClearParams();
            ddlQuizStudentStatus.DataSource = myDal.ExecuteProcedure("SD18EXAM_spGetQuizStudentStatus");
            ddlQuizStudentStatus.DataTextField = "StatusName";
            ddlQuizStudentStatus.DataValueField = "StatusId";
            ddlQuizStudentStatus.DataBind();
        }

        public void loadQuiz()
        {
            DataSet ds = new DataSet();
            myDal.ClearParams();
            myDal.AddParam("@Courseid", ddlCourse.SelectedValue.ToString());
            ds = myDal.ExecuteProcedure("SD18EXAM_spLoadQuizes");

            ddlSelectQuiz.DataTextField = "Title";
            ddlSelectQuiz.DataValueField = "XMLQuizID";
            ddlSelectQuiz.DataSource = ds;
            ddlSelectQuiz.DataBind();
            ddlSelectQuiz.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
            ddlSelectQuiz.SelectedIndex = 0;

        }
        public void loadStudents()
        {
            cblStudents.DataSource = null;
            DataSet ds = LB.LoadStudents(ddlClass.SelectedValue.ToString());
            cblStudents.DataTextField = "Studentname";
            cblStudents.DataValueField = "Userid";
            cblStudents.DataSource = ds;
            cblStudents.DataBind();
        }

        public void ViewQuiz()
        {
            pnlViewQuiz.Visible = true; 
            DataSet ds = new DataSet();
            myDal.ClearParams();
            ds = myDal.ExecuteProcedure("SD18EXAM_spViewQuiz");
            gvViewQuiz.DataSource = ds;
            gvViewQuiz.DataBind();
                   
        }

        protected void btnIssueQuiz_Click(object sender, EventArgs e)
        {
            pnlIssueQuiz.Visible = true;
            pnlUploadQuiz.Visible = false;
            pnlViewQuiz.Visible = false;
            pnlStartQuiz.Visible = false;
            pnlDownload.Visible = false;
            pnlAllocateStudents.Visible = false;
        }

        protected void btnUploadQuiz_Click(object sender, EventArgs e)
        {
            //Response.Redirect("MentorPage.aspx");
            pnlUploadQuiz.Visible = true;
            pnlIssueQuiz.Visible = false;
            pnlViewQuiz.Visible = false;
            gvViewQuiz.Visible = false;
            pnlStartQuiz.Visible = false;
            pnlDownload.Visible = false;
            pnlAllocateStudents.Visible = false;
        }

        protected void btnViewQuiz_Click(object sender, EventArgs e)
        {
           
            pnlDownload.Visible = false;           
            pnlIssueQuiz.Visible = false;
            pnlUploadQuiz.Visible = false;
            pnlStartQuiz.Visible = false;
            pnlAllocateStudents.Visible = false;
           
            pnlViewQuiz.Visible = true;
            pnlViewExam.Visible = true;
            gvViewQuiz.Visible = true;
            ViewQuiz();
          
        }

        // method to remove all namespaces from xml document
        private void RemoveNamespaceAttributes(XmlNode node)
        {

            if (node.Attributes != null)
            {
                for (int i = node.Attributes.Count - 1; i >= 0; i--)
                {
                    if (node.Attributes[i].Name.Contains(':') || node.Attributes[i].Name == "xmlns")
                        node.Attributes.Remove(node.Attributes[i]);
                }
            }

            foreach (XmlNode n in node.ChildNodes)
            {
                RemoveNamespaceAttributes(n);
            }
        }


        // this button validates xml file and then saves it in a temporary folder 'tempXML'
        protected void btnUploadFile_Click(object sender, EventArgs e)
        {
            string confirmValue = Request.Form["confirm_value"];
            if (confirmValue == "Yes")
            {
                XmlDocument fullXml;
                string fileName = Path.GetFileName(fuploadQuiz.PostedFile.FileName);
                string serverPath = Server.MapPath(".") + "\\tempXML\\";

                string strUploadPath = System.IO.Path.GetFileName(fuploadQuiz.PostedFile.FileName.ToString());
                string strUploadExtension = System.IO.Path.GetExtension(fuploadQuiz.PostedFile.FileName.ToString());


                string fullFilePath;
                fullFilePath = serverPath + fuploadQuiz.FileName.ToString();
                if (fuploadQuiz.HasFile)
                {// file upload control on asp.net has no filtering that's why i need to check the file extension first before upload
                    if (strUploadExtension == ".xqz")
                    {
                        fuploadQuiz.PostedFile.SaveAs(serverPath + strUploadPath);
                        // saving xml file content in a string to pass it to stored proc later
                        string xml = File.ReadAllText(fullFilePath);

                        // validating xml file here before inserting into database
                        string xsd = Server.MapPath(".") + "\\" + "validator.xsd";
                        OpenValidate OV = new OpenValidate();
                        OV.ValidateXml(fullFilePath, xsd);
                        if (OV.failed)
                        {
                            Response.Write("<script>alert('The selected file is not in correct format. Please check before trying again!');</script>");
                        }
                        else
                        {
                            // after validation removing all namespaces from xml file before inserting in database
                            fullXml = new XmlDocument();
                            fullXml.LoadXml(xml);
                            RemoveNamespaceAttributes(fullXml.DocumentElement);

                            // saving xml data in database if file is in correct format
                            XmlTextReader xmlreader = new XmlTextReader(serverPath + fileName);
                            DataSet ds = new DataSet();
                            ds.ReadXml(xmlreader);
                            xmlreader.Close();
                            if (ds.Tables.Count != 0)
                            {
                                try
                                {
                                    myDal.ClearParams();
                                    myDal.AddParam("@xml", xml);
                                    DataSet ds1 = myDal.ExecuteProcedure("SD18EXAM_spInsertXMLContent");
                                    if (ds1.Tables[0].Rows[0]["status"].ToString() == "success")
                                        Response.Write("<SCRIPT LANGUAGE='JavaScript'>alert('Upload Successful')</SCRIPT>");
                                    else
                                        Response.Write("<SCRIPT LANGUAGE='JavaScript'>alert('Upload Error. Please try again.')</SCRIPT>");
                                }
                                catch (Exception)
                                {
                                    System.Web.HttpContext.Current.Response.Write("<SCRIPT LANGUAGE='JavaScript'>alert('Error uploading the file or Unkown extension')</SCRIPT>");
                                }
                            }
                        }
                    }
                    else
                    {
                        System.Web.HttpContext.Current.Response.Write("<SCRIPT LANGUAGE='JavaScript'>alert('File could not be uploaded')</SCRIPT>");
                    }

                }
            }
        }

        protected void ddlCourse_SelectedIndexChanged(object sender, EventArgs e)
        {
            cblStudents.Items.Clear();
            DataSet ds = LB.LoadClasses(ddlCourse.SelectedValue.ToString());
            ddlClass.DataTextField = "Classname";
            ddlClass.DataValueField = "Classid";
            ddlClass.DataSource = ds;
            ddlClass.DataBind();
            ddlClass.Items.Insert(0, new ListItem("-Select Class-", String.Empty));
            ddlClass.SelectedIndex = 0;

            loadQuiz();

            DataSet ds1 = LB.LoadQuizes(ddlCourse.SelectedValue.ToString());
            if (ds1.Tables[0].Rows.Count != 0)
            {
                ddlSelectQuiz.DataTextField = "Title";
                ddlSelectQuiz.DataValueField = "XMLQuizID";
                ddlSelectQuiz.DataSource = ds1;
                ddlSelectQuiz.DataBind();
                ddlSelectQuiz.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
                ddlSelectQuiz.SelectedIndex = 0;
                lblQuizDuration.Text = "Select quiz first";
            }

        }

        protected void ddlSelectQuiz_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblQuizDuration.Text = "Select quiz first";
            DataSet ds = LB.LoadQuizVersions(ddlSelectQuiz.SelectedValue.ToString());
            ddlVersion.DataTextField = "Version";
            ddlVersion.DataValueField = "Versionid";
            ddlVersion.DataSource = ds;
            ddlVersion.DataBind();
            ddlVersion.Items.Insert(0, new ListItem("-Select Quiz-", String.Empty));
            ddlVersion.SelectedIndex = 0;
        }

        protected void ddlClass_SelectedIndexChanged(object sender, EventArgs e)
        {
            loadStudents();
            //ScriptManager.RegisterStartupScript(this, GetType(), "CheckAll", "CheckAll('btnUploadFile');", true);
            foreach (ListItem item in cblStudents.Items)
            {//default: all Students are selected
                item.Selected = true;
            }
        }

        protected void ddlVersion_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            ds = LB.LoadQuizInfo(ddlVersion.SelectedValue.ToString());
            lblQuizDuration.Text = ds.Tables[0].Rows[0]["Time"].ToString() + " minutes";
        }

        private void ViewQuizPopUp()
        {
            RenderXML RX = new RenderXML();

            DataSet ds = RX.XMLContent(ddlVersion.SelectedValue.ToString());
            XmlDoc.LoadXml(ds.Tables[0].Rows[0]["XmlFile"].ToString());

            ns = new XmlNamespaceManager(XmlDoc.NameTable);
            ns.AddNamespace("ns", "urn:Question-Schema");
            string xpath = "/ns:Quiz";
            XmlNodeList QuizNode = XmlDoc.SelectNodes(xpath, ns);
            //string x= XmlDoc.InnerXml;
            //DataSet ds1 = new DataSet();
            //ds1.ReadXml(new StringReader(x));
            // string serverPath = Server.MapPath(".") + "\\XSLT_Files\\";

            //  XmlDataSource xmlDS = new XmlDataSource();
            //  xmlDS.Data = XmlDoc.OuterXml;
            //xmlDS.TransformFile = serverPath + "QuestionX.xslt";
            // xmlDS.XPath = "Quiz";

            DLExamDemo.DataSource = QuizNode;
            DLExamDemo.DataBind();
            DLExamDemoFillBlanks.DataSource = QuizNode;
            DLExamDemoFillBlanks.DataBind();
            DLExamDemoTrueFalse.DataSource = QuizNode;
            DLExamDemoTrueFalse.DataBind();
            MPE1.Show();
          

        }

        // this is Quiz Preview on Issue Quiz button
        protected void btnViewDemoQuiz_Click(object sender, EventArgs e)
        {
            ViewQuizPopUp();
        }

        protected void btnPopUpClose_Click(object sender, EventArgs e)
        {
            MPE1.Hide();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string confirmValue = Request.Form["confirm_value"];
            if (confirmValue == "Yes")
            {
                myDal.ClearParams();
                myDal.AddParam("@Versionid", ddlVersion.SelectedValue.ToString());
                myDal.AddParam("@ClassId", ddlClass.SelectedValue.ToString());
                myDal.AddParam("@Mentorid", HttpContext.Current.Session["Userid"].ToString());
                DataSet dsGetNewIssueQuizId = myDal.ExecuteProcedure("SD18EXAM_spIssueNewQuiz");
                string NewId = null;

                if (dsGetNewIssueQuizId.Tables[0].Columns["IssuedQuizId"] != null)
                    NewId = dsGetNewIssueQuizId.Tables[0].Rows[0]["IssuedQuizId"].ToString();

                if (NewId != null)
                {
                    foreach (ListItem Student in cblStudents.Items)
                    {//default: all Students are selected
                        if (Student.Selected == true)
                        {
                            RenderXML RX = new RenderXML();
                            RX.GetNRandomizeXMLContent(ddlVersion.SelectedValue.ToString(), Student, NewId);
                            //RenderXML RX = new RenderXML();
                            //RX.GetNRandomizeXMLContent(ddlVersion.SelectedValue.ToString());
                        }
                    }
                    Response.Write("<SCRIPT>alert('New Quiz has been issued')</SCRIPT>");
                }
            }
        }

        // this is quiz preview on View Quiz button
        protected void lbViewQuiz_Click(object sender, EventArgs e)
        {
            LinkButton linkUpdate = sender as LinkButton;
            GridViewRow grid = (GridViewRow)linkUpdate.NamingContainer;
            string tempID = gvViewQuiz.DataKeys[grid.RowIndex].Value.ToString();
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

        protected void lbDownloadQuiz_Click(object sender, EventArgs e)
        {
            LinkButton linkUpdate = sender as LinkButton;
            GridViewRow grid = (GridViewRow)linkUpdate.NamingContainer;
            string tempID = gvViewQuiz.DataKeys[grid.RowIndex].Value.ToString();
            ViewState["tempId"] = tempID;

            RenderXML RX = new RenderXML();

            DataSet ds = RX.XMLContent(tempID);
            XmlDoc.LoadXml(ds.Tables[0].Rows[0]["XmlFile"].ToString());

            //string QuizTitle =  gvViewQuiz.SelectedRow.Cells[3].Text;

            string filePath = Server.MapPath(DateTime.Now.ToString("yyyyMMddHHmmss") + ".xqz");

            XmlDoc.Save(filePath);

            string fileName = DateTime.Now.ToString("yyyyMMddHHmmss") + ".xqz";

            Response.AppendHeader("content-disposition", "attachment; filename=" + fileName);

            string type = "";
            if (type != "")
                Response.ContentType = type;
            Response.WriteFile(filePath);
            Response.End();
            XmlDoc.Save(Response.OutputStream);

        }


        protected void btnStartQuiz_Click(object sender, EventArgs e)
        {
            pnlAllocateStudents.Visible = false;
            pnlStartQuiz.Visible = true;
            pnlIssueQuiz.Visible = false;
            pnlViewQuiz.Visible = false;
            pnlUploadQuiz.Visible = false;
            gvViewQuiz.Visible = false;
            pnlDownload.Visible = false;
            LoadQuizStatus();
           
        }

        private void LoadQuizStatus()
        {
            gvQuizes.DataSource = null;
            gvQuizes.DataBind();

            myDal.ClearParams();
            myDal.AddParam("@Userid", HttpContext.Current.Session["Userid"].ToString());
            DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spGetIssuedQuizByMentor");
            if (ds.Tables[0].Rows.Count != 0)
            {
                pnlStartQuiz.Visible = true;
                gvQuizes.DataSource = ds.Tables[0];
                gvQuizes.DataBind();


            }
        }

        protected void gvQuizes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Action")
            {
                int IssuedQuizId = -1;
                gvQuizes.SelectedIndex = Convert.ToInt32(e.CommandArgument.ToString());
                IssuedQuizId = Convert.ToInt32(gvQuizes.SelectedDataKey.Values[0].ToString());
                PopUpQuizAction(IssuedQuizId);
            }
        }
        private void PopUpQuizAction(int IssuedQuizId)
        {
            if (IssuedQuizId != -1)
            {
                myDal.ClearParams();
                myDal.AddParam("@IssuedQuizId", IssuedQuizId.ToString());
                DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spgetIssuedQuizDetails");
                if (ds.Tables[0].Rows.Count != 0)
                {
                    lblIssuedQuizId.Text = ds.Tables[0].Rows[0]["IssuedQuizId"].ToString();
                    lblTitle.Text = ds.Tables[0].Rows[0]["Title"].ToString();
                    lblTime.Text = ds.Tables[0].Rows[0]["Time"].ToString();
                    lblClass.Text = ds.Tables[0].Rows[0]["Classname"].ToString();
                    lblStatus.Text = ds.Tables[0].Rows[0]["StatusName"].ToString();

                    //load Student
                    //ddlActionQuizStudent
                    myDal.ClearParams();
                    myDal.AddParam("@IssuedQuizId", IssuedQuizId);
                    ddlActionQuizStudent.DataSource = myDal.ExecuteProcedure("SD18EXAM_spGetStudentsFromIssuedQuizID");
                    ddlActionQuizStudent.DataTextField = "Name";
                    ddlActionQuizStudent.DataValueField = "QuizStudentid";
                    ddlActionQuizStudent.DataBind();
                    ddlActionQuizStudent.Items.Insert(0, new ListItem("Please select", "-1"));

                    
                    //SD18EXAM_spGetStudentResponseDetails
                    MPEQuizAction.Show();
                }
            }
        }

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            pnlDownload.Visible = true;
            pnlStartQuiz.Visible = false;
            pnlIssueQuiz.Visible = false;
            pnlUploadQuiz.Visible = false;
            pnlViewQuiz.Visible = false;
            pnlAllocateStudents.Visible = false;
        }

        protected void btnClosePopUp_Click(object sender, EventArgs e)
        {
            MPEQuizAction.Hide();
            
        }

        protected void btnStart_Click(object sender, EventArgs e)
        {
            //MPEQuizAction.Show();

            myDal.ClearParams();
            myDal.AddParam("@IssuedQuizId", lblIssuedQuizId.Text);
            DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spStartQuiz");
            PopUpQuizAction(Convert.ToInt32(lblIssuedQuizId.Text));


            LoadQuizStatus();
           

        }

        protected void btnReports_Click(object sender, EventArgs e)
        {
            Response.Redirect("Reports.aspx");
        }

        protected void btnEnd_Click(object sender, EventArgs e)
        {
            myDal.ClearParams();
            myDal.AddParam("@IssuedQuizId", lblIssuedQuizId.Text);
            myDal.AddParam("@MentorId", HttpContext.Current.Session["Userid"].ToString());
            myDal.AddParam("@Action", "CloseQuiz");
            DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spActionQuiz");
            if (ds.Tables.Count != 0)//not null
            {
                switch (ds.Tables[0].Rows[0]["status"].ToString())
                {
                    case "closeSuccess":
                        Response.Write("<SCRIPT>alert('Quiz Closed')</SCRIPT>");
                        break;
                    case "InvalidQuiz":
                        Response.Write("<SCRIPT>alert('Cannot close this because it is invalid Quiz')</SCRIPT>");
                        break;
                    case "userlevelNotEnough":
                        Response.Write("<SCRIPT>alert('User Account level is not enough!')</SCRIPT>");
                        break;

                    default:
                        Response.Write("<SCRIPT>alert('Error(s) Found.')</SCRIPT>");
                        break;
                }
                
            }
            PopUpQuizAction(Convert.ToInt32(lblIssuedQuizId.Text));
            MPEQuizAction.Show();
            LoadQuizStatus();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string confirmValue = Request.Form["confirm_value"];
            if (confirmValue == "Yes")
            {
                myDal.ClearParams();
                myDal.AddParam("@IssuedQuizId", lblIssuedQuizId.Text);
                myDal.AddParam("@MentorId", HttpContext.Current.Session["Userid"].ToString());
                myDal.AddParam("@Action", "DeleteQuiz");
                DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spActionQuiz");
                if (ds.Tables.Count != 0)//not null
                {
                    switch (ds.Tables[0].Rows[0]["status"].ToString())
                    {
                        case "QuizDeleted":
                            Response.Write("<SCRIPT>alert('Quiz Deleted')</SCRIPT>");
                            break;
                        case "QuizNotFound":
                            Response.Write("<SCRIPT>alert('Cannot Delete this because it is invalid Quiz')</SCRIPT>");
                            break;
                        default:
                            Response.Write("<SCRIPT>alert('Error(s) Found.')</SCRIPT>");
                            break;
                    }
                }
                
            }
            else
            {
                MPEQuizAction.Show();
            }
            LoadQuizStatus();
        }
        private void refreshStudentGrid()
        {
            pnlAddToClass.Visible = false;
            gvAllocateStudents.DataSource = null;
            gvAllocateStudents.DataBind();
            myDal.ClearParams();
            DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spGetUnAssignedStudents");
            if (ds.Tables[0].Rows.Count != 0)
            {
                gvAllocateStudents.DataSource = ds.Tables[0];
                gvAllocateStudents.DataBind();
                pnlAddToClass.Visible = true;
            }
        }
        protected void btnAllocateStudents_Click(object sender, EventArgs e)
        {
            refreshStudentGrid();
            DataSet ds = new DataSet();
            myDal.ClearParams();
            ds.Clear();
            ds = myDal.ExecuteProcedure("SD18EXAM_spGetClass");
            if (ds.Tables[0].Rows.Count != 0)
            {
                ddlAssignClass.DataSource = ds.Tables[0];
                ddlAssignClass.DataValueField = "Classid";
                ddlAssignClass.DataTextField = "Classname";
                ddlAssignClass.DataBind();
            }
            pnlIssueQuiz.Visible = false;
            pnlAllocateStudents.Visible = true;
            pnlViewQuiz.Visible = false;
            pnlStartQuiz.Visible = false;
            pnlUploadQuiz.Visible = false;
            pnlDownload.Visible = false;
        }

        protected void btnAccept_Click(object sender, EventArgs e)
        {
            string confirmValue = Request.Form["confirm_value"];
            if (confirmValue == "Yes")
            {
                List<string> Errors = new List<string>();
                if (ddlAssignClass.SelectedIndex != -1)
                {
                    foreach (GridViewRow row in gvAllocateStudents.Rows)
                    {
                        if (((CheckBox)row.FindControl("CBUser")).Checked)
                        {
                            gvAllocateStudents.SelectedIndex = row.DataItemIndex;
                            string UserID = gvAllocateStudents.SelectedDataKey.Value.ToString();
                            myDal.ClearParams();
                            myDal.AddParam("@UserID", UserID);
                            myDal.AddParam("@ClassID", ddlAssignClass.SelectedValue.ToString());
                            DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spAllocateStudent");
                            if (ds.Tables[0].Rows.Count != 0)
                            {
                                if (ds.Tables[0].Rows[0]["status"] != null)
                                {
                                    switch (ds.Tables[0].Rows[0]["status"].ToString())
                                    {
                                        case "UserNotFound":
                                            Errors.Add("User Not Found: " + gvAllocateStudents.SelectedDataKey.Value.ToString());
                                            break;
                                        case "Failed":
                                            Errors.Add("Operation Failed at USERID: " + gvAllocateStudents.SelectedDataKey.Value.ToString());
                                            break;
                                        default:
                                            break;
                                    }
                                }
                                else
                                {
                                    Response.Write("<SCRIPT>alert('Error in Retrieving values on database. Please Try again.')</SCRIPT>");
                                }
                            }
                            else
                            {
                                Response.Write("<SCRIPT>alert('Error in Retrieving values on database. Please Try again.')</SCRIPT>");
                            }
                        }
                    }
                    if (Errors.Count != 0)
                    {
                        foreach (string LI in Errors)
                        {
                            Response.Write("<SCRIPT>alert('" + LI.ToString() + "')</SCRIPT>");
                        }
                    }
                }
                else
                {
                    Response.Write("<SCRIPT>alert('Please select class to assign')</SCRIPT>");
                }
            }
            refreshStudentGrid();
        }

        protected void ddlActionQuizStudent_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(ddlActionQuizStudent.SelectedIndex != -1 || ddlActionQuizStudent.SelectedValue != "-1")
            {
                myDal.ClearParams();
                myDal.AddParam("@QuizStudentid", ddlActionQuizStudent.SelectedValue.ToString());
                DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spStudentQuizInfoUser");
                ddlActionQuizStudent.SelectedIndex = ddlActionQuizStudent.Items.IndexOf(ddlActionQuizStudent.Items.FindByText(ds.Tables[0].Rows[0]["StatusName"].ToString()));

            }
            MPEQuizAction.Show();
        }

        protected void btnAcceptChanges_Click(object sender, EventArgs e)
        {
             string confirmValue = Request.Form["confirm_value"];
             if (confirmValue == "Yes")
             {
                 myDal.ClearParams();
                 myDal.AddParam("@QuizStudentid", ddlActionQuizStudent.SelectedValue.ToString());
                 myDal.AddParam("@StatusId", ddlQuizStudentStatus.SelectedValue.ToString());
                 DataSet ds = myDal.ExecuteProcedure("SD18EXAM_spUpdateQuizStudentStatus");
                 if (ds.Tables[0].Rows[0]["status"].ToString() == "success")
                 {
                     Response.Write("<SCRIPT>alert('Student quiz status change SUCCESSFULL')</SCRIPT>");
                 }
                 else
                     Response.Write("<SCRIPT>alert('Student quiz status change FAILED')</SCRIPT>");
             }

        }

        protected void btnCancelChanges_Click(object sender, EventArgs e)
        {
            MPEQuizAction.Hide();
        }

    }
}