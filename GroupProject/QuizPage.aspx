﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="QuizPage.aspx.cs" Inherits="GroupProject.QuizPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="js/jquery-2.1.1.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            answers = new Object();
            $('.option').change(function () {
                var answer = ($(this).attr('value'))
                var question = ($(this).attr('name'))
                var ChoicePosition = ($(this).attr('id'))
                // answers[question] = answer
                var select = [answer, ChoicePosition]
                answers[question] = select

            });
            $('#tempXML').change(function () {// fire the ajax here! to save
                alert("valueCHanged");
            })

            var item1 = document.getElementById('Question');

            var totalQuestions = $('.Question').size();
            var currentQuestion = 0;
            $questions = $('.Question');
            $questions.hide();
            $($questions.get(currentQuestion)).fadeIn();
            $('#next').click(function () {
                $($questions.get(currentQuestion)).fadeOut(function () {
                    currentQuestion = currentQuestion + 1;
                    if (currentQuestion == totalQuestions) {
                        var result = sum_values()
                        //do stuff with the result
                        alert(result);
                    } else {
                        var result = sum_values()
                        $($questions.get(currentQuestion)).fadeIn();
                    }
                });
            });
            $('#back').click(function () {
                $($questions.get(currentQuestion)).fadeOut(function () {
                    currentQuestion = currentQuestion - 1;
                    if (currentQuestion == totalQuestions) {
                        var result = sum_values()
                        //do stuff with the result
                        alert(result);
                    } else {
                        $($questions.get(currentQuestion)).fadeIn();
                    }
                });
            });
            function sum_values() {
                var the_sum = 0;
                var NewXMLwithAnswers;
                for (questions in answers) {
                    the_sum = the_sum + parseInt(answers[questions][0])
                    var position = answers[questions][1]
                    var questionId = questions
                    questionId = questionId.replace('Question', '')
                    NewXMLwithAnswers=  RecreateXML(questionId, position)
                    //var MyData ='{"QuestionID": "'+questionId.replace('Question','')+', "position"}'
                }
                if (NewXMLwithAnswers != null)
                {
                    var UserID = '<%=HttpContext.Current.Session["Userid"]%>';
                    setSession(NewXMLwithAnswers, UserID,the_sum)
                }
                return the_sum
            }
            function RecreateXML(QuestionID, UserAnswerPosition) {
                // var xmlFile = '<%=HttpContext.Current.Session["Quiz"]%>';
                var xmlFile;
                if (document.getElementById("tempXML").value != "") {
                    xmlFile = document.getElementById("tempXML").value;
                }
                else {
                    xmlFile = '<%=HttpContext.Current.Session["Quiz"]%>';
                }
                // xmlFile = '<%=HttpContext.Current.Session["Quiz"]%>';
                // var QuestionElement = $($.parseXML(xmlFile)).find("Question[ID=QuestionID]");
                XMLDoc = $.parseXML(xmlFile)
                $xmlFile = $(XMLDoc)
                $Question = $xmlFile.find("Question[ID='" + QuestionID + "']");
                $Option = $xmlFile.find("Question[ID='" + QuestionID + "']").find("Options");
                $Option = $Question.find("Options");
                //the UserAnswerPosition starts from 1 but the find xml content starts with 0; therefore we need to less the position by one
                fixPosition = UserAnswerPosition - 1
                //$OptionSelected now holds the Answer of the user. the TEXT answer
                $OptionSelected = $Option.find("Option:eq('" + fixPosition + "')").text();
                //Append the OptionSelected to USERANSWER element
                if ($Question.attr('done') == undefined)
                {
                    $Question.attr('done', 'true'); //mark the question done!
                    $($.parseXML('<UserAnswer>' + $OptionSelected + '</UserAnswer>')).find("UserAnswer").appendTo($Question);
                }
                else
                {
                    $Question.attr('done', 'true'); //mark the question done!
                    $($.parseXML('<UserAnswer>' + $OptionSelected + '</UserAnswer>')).replaceAll("UserAnswer").appendTo($Question);
                }
                
                //x = XMLDoc.getElementsByTagName("Question");
                var XMLString;
                //IE
                if (window.ActiveXObject) {
                    XMLString = XMLDoc;
                }
                    // code for Mozilla, Firefox, Opera, etc.
                else {
                    XMLString = (new XMLSerializer()).serializeToString(XMLDoc);
                }
                document.getElementById("tempXML").value = XMLString
                return XMLString;
                //alert(XMLString);
                //var UserID = '<%=HttpContext.Current.Session["Userid"]%>';
               // setSession(XMLString, UserID)

            }
            function setSession(XMLString, UserID, the_sum) {
                //$("input:hidden[id$=tempXML]").val(XMLString)
                //                               .trigger('change');
                //var var1 = '{"var1": "' + XMLString + '"}'
                var var1 = '{"var1": "' + escape(XMLString) + '"}';
                var QuizStudentId = '<%=HttpContext.Current.Session["QuizStudentId"]%>';
                var SendToServer = '{"var1": "' + escape(XMLString) + '", "var2": "' + UserID + '", "var3": "' +QuizStudentId+'", "var4": "'+the_sum+'"}'
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: var1,
                    url: "QuizPage.aspx/SaveValueInSession",
                    dataType: "json",
                    success: function (data) {
                        alert(data.d);
                        SendToServerAndStatus(SendToServer);
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        debugger;
                    }
                })
            }

            function SendToServerAndStatus(sendtoserver) {
                
                $.ajax({
                    type: "POST",
                    contentType: "application/json",
                    data: sendtoserver,
                    url: "QuizHandler.ashx",
                    dataType: "json",
                    success: function (data, status) {
                        //alert(data.d);
                        console.log(data);
                        alert(JSON.stringify(data));
                        alert(data.status)// getting the data.d values
                    },
                    error: function (error) {
                        alert("Error: " + error.status + "/ " +
                          error.statusText);
                        debugger;
                    }
                })
            }

        })

    </script>

    <div>
        <asp:Xml ID="XMLquiz" runat="server"></asp:Xml>
        <input type="button" id="back" name="back" value="BACK" />
        <input type="button" id="next" name="next" value="NEXT" />
        <input type="hidden" name="tempXML" id="tempXML" />
        <%--use the hiddenfield to SET the SESSION since it cannot set by SERVER using JAVASCRIPT. but i can retrieve it from USER BROWSER. --%>
    </div>
</asp:Content>
