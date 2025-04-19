#!/bin/bash

# Student data file
data_file="students.txt"

# Function to add a student
add_student() {
    if [ $(wc -l < "$data_file") -ge 20 ]; then
        echo "Cannot add more students. Limit reached."
        return
    fi
    echo "Enter Roll Number: "
    read roll
    echo "Enter Name: "
    read name
    echo "$roll|$name||0|0.0|F" >> "$data_file"
    echo "Student added successfully."
}

# Function to view student details
view_students() {
    echo "1. View All Students"
    echo "2. Search Student by Roll Number"
    read -p "Choose an option: " option
    
    if [ "$option" -eq 1 ]; then
        echo "Roll No | Name | Courses | Marks | CGPA | Grade"
        echo "---------------------------------------------"
        cat "$data_file"
    elif [ "$option" -eq 2 ]; then
        echo "Enter Roll Number: "
        read roll
        grep "^$roll|" "$data_file"
    else
        echo "Invalid option."
    fi
}

# Function to delete a student
delete_student() {
    echo "Enter Roll Number to delete: "
    read roll
    grep -v "^$roll|" "$data_file" > temp.txt && mv temp.txt "$data_file"
    echo "Student deleted successfully."
}

# Function to assign marks and grades for a course
assign_marks() {
    echo "Enter Roll Number: "
    read roll
    echo "Enter Course Name: "
    read course
    echo "Enter Marks for $course: "
    read marks
    
    # Calculate Grade and CGPA
    if [ "$marks" -ge 95 ]; then
        grade="A+"; cgpa=4.0
    elif [ "$marks" -ge 90 ]; then
        grade="A"; cgpa=3.7
    elif [ "$marks" -ge 85 ]; then
        grade="A-"; cgpa=3.3
    elif [ "$marks" -ge 80 ]; then
        grade="B+"; cgpa=3.0
    elif [ "$marks" -ge 75 ]; then
        grade="B"; cgpa=2.7
    elif [ "$marks" -ge 70 ]; then
        grade="B-"; cgpa=2.3
    elif [ "$marks" -ge 65 ]; then
        grade="C+"; cgpa=2.0
    elif [ "$marks" -ge 60 ]; then
        grade="C"; cgpa=1.7
    elif [ "$marks" -ge 55 ]; then
        grade="C-"; cgpa=1.3
    elif [ "$marks" -ge 50 ]; then
        grade="D"; cgpa=1.0
    else
        grade="F"; cgpa=0.0
    fi

    # Update student record
    awk -F '|' -v roll="$roll" -v course="$course" -v marks="$marks" -v grade="$grade" -v cgpa="$cgpa" '
    BEGIN { OFS="|" }
    {
        if ($1 == roll) {
            if ($3 == "") {
                $3 = course;
            } else {
                $3 = $3 "," course;
            }
            $4 = marks;
            $5 = cgpa;
            $6 = grade;
        }
        print $0;
    }' "$data_file" > temp.txt && mv temp.txt "$data_file"
    echo "Marks and grades updated for $course."
}

# Function to list passed students
list_passed_students() {
    echo "Passed Students (CGPA > 2.0)"
    awk -F '|' '$5 > 2.0 {print $0}' "$data_file"
}

# Function to list failed students
list_failed_students() {
    echo "Failed Students (CGPA <= 2.0)"
    awk -F '|' '$5 <= 2.0 {print $0}' "$data_file"
}

# Function to sort students by CGPA
sort_students() {
    echo "1. Ascending Order"
    echo "2. Descending Order"
    read -p "Choose an option: " order
    if [ "$order" -eq 1 ]; then
        sort -t '|' -k5 -n "$data_file"
    elif [ "$order" -eq 2 ]; then
        sort -t '|' -k5 -nr "$data_file"
    else
        echo "Invalid option."
    fi
}

# Function to generate a student report
generate_report() {
    echo "Roll No | Name | Courses | Marks | CGPA | Grade | Status"
    echo "--------------------------------------------------------"
    awk -F '|' '{status = ($5 >= 2.0) ? "Pass" : "Fail"; print $1"|"$2"|"$3"|"$4"|"$5"|"$6"|"status}' "$data_file" | sort -t '|' -k5 -nr
}

# Teacher menu
teacher_menu() {
    while true; do
        echo "1. Add Student"
        echo "2. View Students"
        echo "3. Delete Student"
        echo "4. Assign Marks & Grades for Course"
        echo "5. List Passed Students"
        echo "6. List Failed Students"
        echo "7. Sort Students"
        echo "8. Generate Student Report"
        echo "9. Logout"
        read -p "Choose an option: " choice
        case $choice in
            1) add_student ;;
            2) view_students ;;
            3) delete_student ;;
            4) assign_marks ;;
            5) list_passed_students ;;
            6) list_failed_students ;;
            7) sort_students ;;
            8) generate_report ;;
            9) exit ;;
            *) echo "Invalid option" ;;
        esac
    done
}

# Student menu
student_menu() {
    echo "Enter Roll Number: "
    read roll
    while true; do
        echo "1. View Grades per Course"
        echo "2. View CGPA"
        echo "3. Logout"
        read -p "Choose an option: " choice
        case $choice in
            1) grep "^$roll|" "$data_file" | awk -F '|' '{print "Courses: "$3" | Marks: "$4" | Grade: "$6}' ;;
            2) grep "^$roll|" "$data_file" | awk -F '|' '{print "CGPA: "$5}' ;;
            3) exit ;;
            *) echo "Invalid option" ;;
        esac
    done
}

# Main menu
main_menu() {
    echo "1. Teacher Login"
    echo "2. Student Login"
    read -p "Choose your role: " role
    case $role in
        1) teacher_menu ;;
        2) student_menu ;;
        *) echo "Invalid option" ;;
    esac
}

# Run main menu
main_menu

