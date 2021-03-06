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
    public partial class testxsl : System.Web.UI.Page
    {
        DAL myDal = new DAL(Globals.conn);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                loadXML();
            }
        }

        private void loadXML()
        {
            //Load XML 
            myDal.ClearParams();
            DataSet dataSet = new DataSet();
            dataSet = myDal.ExecuteProcedure("spGetTestSample");

            Xml1.DocumentContent = dataSet.Tables[0].Rows[0]["XMLQuiz"].ToString();
            //Xml1.DocumentSource = "Quiz.xml";
            Xml1.TransformSource = "Quiz.xsl";

        }
    }
}
