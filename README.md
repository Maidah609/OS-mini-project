# OS-mini-project(Student Management System) 
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
    
    if ! [[ "$roll" =~ ^[0-9]+$ ]]; then
        echo "Invalid roll number. Must be digits only."
        return
    fi

    
    if grep -q "^$roll|" "$data_file"; then
        echo "A student with this roll number already exists."
        return
    fi

    echo "Enter Name: "
    read name
    if ! [[ "$name" =~ ^[a-zA-Z\ ]+$ ]]; then
        echo "Invalid name. Only letters and spaces are allowed."
        return
    fi

    echo "$roll|$name|||0.0|F" >> "$data_file"
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

# Function to calculate CGPA
calculate_cgpa() {
    local total=0
    local count=0
    for mark in "${marks_array[@]}"; do
        if [ "$mark" -ge 95 ]; then gp=4.0
        elif [ "$mark" -ge 90 ]; then gp=3.7
        elif [ "$mark" -ge 85 ]; then gp=3.3
        elif [ "$mark" -ge 80 ]; then gp=3.0
        elif [ "$mark" -ge 75 ]; then gp=2.7
        elif [ "$mark" -ge 70 ]; then gp=2.3
        elif [ "$mark" -ge 65 ]; then gp=2.0
        elif [ "$mark" -ge 60 ]; then gp=1.7
        elif [ "$mark" -ge 55 ]; then gp=1.3
        elif [ "$mark" -ge 50 ]; then gp=1.0
        else gp=0.0; fi
        total=$(echo "$total + $gp" | bc)
        count=$((count + 1))
    done

    if [ "$count" -eq 0 ]; then
        echo "0.0"
    else
        printf "%.2f" $(echo "$total / $count" | bc -l)
    fi
}

# Function to get overall grade
get_grade() {
    local cgpa=$1
    if (( $(echo "$cgpa >= 4.0" | bc -l) )); then echo "A+"
    elif (( $(echo "$cgpa >= 3.7" | bc -l) )); then echo "A"
    elif (( $(echo "$cgpa >= 3.3" | bc -l) )); then echo "A-"
    elif (( $(echo "$cgpa >= 3.0" | bc -l) )); then echo "B+"
    elif (( $(echo "$cgpa >= 2.7" | bc -l) )); then echo "B"
    elif (( $(echo "$cgpa >= 2.3" | bc -l) )); then echo "B-"
    elif (( $(echo "$cgpa >= 2.0" | bc -l) )); then echo "C+"
    elif (( $(echo "$cgpa >= 1.7" | bc -l) )); then echo "C"
    elif (( $(echo "$cgpa >= 1.3" | bc -l) )); then echo "C-"
    elif (( $(echo "$cgpa >= 1.0" | bc -l) )); then echo "D"
    else echo "F"; fi
}

# Helper function to convert mark to grade point
get_grade_point() {
    local mark=$1
    if [ "$mark" -ge 95 ]; then echo "A+"
    elif [ "$mark" -ge 90 ]; then echo "A"
    elif [ "$mark" -ge 85 ]; then echo "A-"
    elif [ "$mark" -ge 80 ]; then echo "B+"
    elif [ "$mark" -ge 75 ]; then echo "B"
    elif [ "$mark" -ge 70 ]; then echo "B-"
    elif [ "$mark" -ge 65 ]; then echo "C+"
    elif [ "$mark" -ge 60 ]; then echo "C"
    elif [ "$mark" -ge 55 ]; then echo "C-"
    elif [ "$mark" -ge 50 ]; then echo "D"
    else echo "F"; fi
}

# Function to display per-course grades
display_grades() {
    local roll=$1
    line=$(grep "^$roll|" "$data_file")
    if [ -z "$line" ]; then
        echo "Student not found."
        return
    fi
    IFS='|' read -r r n courses marks_list cgpa grade <<< "$line"
    IFS=',' read -ra course_array <<< "$courses"
    IFS=',' read -ra marks_array <<< "$marks_list"

    echo "Grades for Roll Number: $roll"
    for ((i = 0; i < ${#course_array[@]}; i++)); do
        mark=${marks_array[i]}
        course=${course_array[i]}
        g=$(get_grade_point "$mark")
        echo "Course: $course | Marks: $mark | Grade: $g"
    done
}

# Function to assign marks and grades for a course
assign_marks() {
    echo "Enter Roll Number: "
    read roll
    echo "Enter Course Name: "
    read course
    echo "Enter Marks for $course: "
    read marks

    if ! [[ "$marks" =~ ^[0-9]+$ ]] || [ "$marks" -lt 0 ] || [ "$marks" -gt 100 ]; then
        echo "Invalid marks. Please enter a number between 0 and 100."
        return
    fi

    awk -F '|' -v roll="$roll" -v course="$course" -v marks="$marks" '
    BEGIN { OFS="|" }
    {
        if ($1 == roll) {
            n_courses = split($3, cArr, ",")
            n_marks = split($4, mArr, ",")
            found = 0
            for (i = 1; i <= n_courses; i++) {
                if (cArr[i] == course) {
                    mArr[i] = marks
                    found = 1
                }
            }
            if (!found) {
                cArr[n_courses+1] = course
                mArr[n_marks+1] = marks
                n_courses++
                n_marks++
            }

            newCourses = cArr[1]
            newMarks = mArr[1]
            for (i = 2; i <= n_courses; i++) {
                newCourses = newCourses "," cArr[i]
                newMarks = newMarks "," mArr[i]
            }

            $3 = newCourses
            $4 = newMarks
        }
        print $0
    }' "$data_file" > temp.txt && mv temp.txt "$data_file"

    line=$(grep "^$roll|" "$data_file")
    IFS='|' read -r r n courses marks_list old_cgpa old_grade <<< "$line"
    IFS=',' read -ra marks_array <<< "$marks_list"

    new_cgpa=$(calculate_cgpa)
    new_grade=$(get_grade "$new_cgpa")

    awk -F '|' -v roll="$roll" -v cgpa="$new_cgpa" -v grade="$new_grade" '
    BEGIN { OFS="|" }
    {
        if ($1 == roll) {
            $5 = cgpa;
            $6 = grade;
        }
        print $0;
    }' "$data_file" > temp.txt && mv temp.txt "$data_file"

    echo "Marks and grades updated for $course."
}


# Function to list passed students
list_passed_students() {
    echo "Passed Students (CGPA >= 2.0)"
    awk -F '|' '$5 >= 2.0 {print $0}' "$data_file"
}

# Function to list failed students
list_failed_students() {
    echo "Failed Students (CGPA < 2.0)"
    awk -F '|' '$5 < 2.0 {print $0}' "$data_file"
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
    awk -F '|' '{
        status = ($5 >= 2.0) ? "Pass" : "Fail"
        print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" status
    }' "$data_file" | sort -t '|' -k5 -nr
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
            1) display_grades "$roll" ;;
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
