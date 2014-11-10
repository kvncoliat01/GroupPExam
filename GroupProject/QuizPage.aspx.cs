﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL_Project;
using System.Data;

namespace GroupProject
{
    public partial class QuizPage : System.Web.UI.Page
    {
        DAL myDal = new DAL(Globals.conn);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                loadXML();
            }
        }
        private void loadXML()
        {
            //Load XML 
            //i can use session to retrieve xml file
            if (HttpContext.Current.Session["Quiz"] != null)
            {
                XMLquiz.DocumentContent = HttpContext.Current.Session["Quiz"].ToString();
            }
            else
            {
                myDal.ClearParams();
                DataSet dataSet = new DataSet();
                dataSet = myDal.ExecuteProcedure("spGetTestSample");
                XMLquiz.DocumentContent = dataSet.Tables[0].Rows[0]["XMLQuiz"].ToString();
            }
            XMLquiz.TransformSource = "Quiz.xsl";

        }
    }
}