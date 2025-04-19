<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Record Management System - Bash Script</title>
</head>
<body>

<h1>🎓 Student Record Management System</h1>
<p>This project is a simple <strong>command-line Student Record Management System</strong> written in Bash. It manages student data such as names, roll numbers, courses, marks, grades, and CGPAs.</p>

<h2>📁 Features</h2>
<ul>
  <li>Add, delete, or view student details</li>
  <li>Assign marks and auto-generate grades and CGPA</li>
  <li>List students who passed or failed</li>
  <li>Sort students by CGPA (ascending or descending)</li>
  <li>Generate a complete student report with pass/fail status</li>
  <li>Separate menus for <strong>Teacher</strong> and <strong>Student</strong> login</li>
</ul>

<h2>🗂 Data Structure</h2>
<p>Student records are stored in a text file named <code>students.txt</code> using the following pipe-separated format:</p>
<pre>
RollNumber|Name|Courses|Marks|CGPA|Grade
</pre>
<p>Example:</p>
<pre>
0631|Anza|PF,PF|90|3.7|A
0764|Maidah|OOP|45|0.0|F
</pre>

<h2>🚀 How to Run on Ubuntu</h2>
<ol>
  <li>Make sure you have Bash installed (should be present by default on Ubuntu).</li>
  <li>Open the terminal and clone or copy the script files to your working directory.</li>
  <li>Ensure the script is executable:</li>
  <pre><code>chmod +x project.sh</code></pre>
  <li>Create an empty <code>students.txt</code> file if it doesn't exist yet:</li>
  <pre><code>touch students.txt</code></pre>
  <li>Run the script:</li>
  <pre><code>./project.sh</code></pre>
</ol>

<h2>🔐 User Roles</h2>
<h3>1. Teacher Login</h3>
<p>Options available to a teacher:</p>
<ol>
  <li>Add Student</li>
  <li>View Students (all or by roll number)</li>
  <li>Delete Student</li>
  <li>Assign Marks & Grades</li>
  <li>List Passed Students (CGPA > 2.0)</li>
  <li>List Failed Students (CGPA ≤ 2.0)</li>
  <li>Sort Students by CGPA</li>
  <li>Generate Student Report</li>
  <li>Logout</li>
</ol>

<h3>2. Student Login</h3>
<p>Options available to a student:</p>
<ol>
  <li>View grades and courses</li>
  <li>View CGPA</li>
  <li>Logout</li>
</ol>

<h2>🧠 How Grades Are Calculated</h2>
<p>Grades and CGPA are automatically assigned based on marks:</p>
<table border="1" cellpadding="4">
  <thead>
    <tr><th>Marks</th><th>Grade</th><th>CGPA</th></tr>
  </thead>
  <tbody>
    <tr><td>95+</td><td>A+</td><td>4.0</td></tr>
    <tr><td>90–94</td><td>A</td><td>3.7</td></tr>
    <tr><td>85–89</td><td>A-</td><td>3.3</td></tr>
    <tr><td>80–84</td><td>B+</td><td>3.0</td></tr>
    <tr><td>75–79</td><td>B</td><td>2.7</td></tr>
    <tr><td>70–74</td><td>B-</td><td>2.3</td></tr>
    <tr><td>65–69</td><td>C+</td><td>2.0</td></tr>
    <tr><td>60–64</td><td>C</td><td>1.7</td></tr>
    <tr><td>55–59</td><td>C-</td><td>1.3</td></tr>
    <tr><td>50–54</td><td>D</td><td>1.0</td></tr>
    <tr><td>&lt; 50</td><td>F</td><td>0.0</td></tr>
  </tbody>
</table>

<h2>🔧 Internal Function Breakdown</h2>
<ul>
  <li><code>add_student()</code>: Adds a student with default values. Enforces a max limit of 20.</li>
  <li><code>view_students()</code>: View all students or search by roll number.</li>
  <li><code>delete_student()</code>: Deletes a student entry based on roll number.</li>
  <li><code>assign_marks()</code>: Updates a student's course, marks, CGPA, and grade.</li>
  <li><code>list_passed_students()</code>: Lists all students with CGPA > 2.0.</li>
  <li><code>list_failed_students()</code>: Lists all students with CGPA ≤ 2.0.</li>
  <li><code>sort_students()</code>: Sorts student list by CGPA ascending/descending.</li>
  <li><code>generate_report()</code>: Shows full student report with Pass/Fail tag.</li>
</ul>

<h2>🧪 Sample Usage</h2>
<pre>
> ./project.sh
Choose your role:
1. Teacher Login
2. Student Login
</pre>

<h2>👨‍💻 Contributing</h2>
<p>Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.</p>

<h2>📜 License</h2>
<p>This project is open source and available under the MIT License.</p>

</body>
</html>
