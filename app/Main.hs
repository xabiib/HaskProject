{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Applicative
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import Data.Text

databaseName = "project.db" :: String
--types
data Student         = Student { userId :: Int , firstName :: String, lastName  :: String } -- deriving Show
data Course          = Course { courseId :: Int , name :: String , code :: String  , maxStudent :: Int  }
data AllRegistration = AllRegistration    {      uId :: Int   , fName :: String   , lName   , cName :: String   }
 --types

--instances
instance Show Student where show user   = mconcat [ show $ userId user  , "\t"  , firstName user , "\t" , lastName user ]
instance Show Course where  show course = mconcat [ show $ courseId course , "\t" , name course, "\t\t", code course , "\t\t"  , (show $ maxStudent course ) , "\n"]
instance Show AllRegistration where show reg = mconcat [ show $ uId reg  , "\t" , fName reg , "\t" , lName reg , "\t"  , cName reg   , "\n"]

--for converting a row of results returned by a SQL query into a more useful Haskell representation.
instance FromRow Student where fromRow         = Student <$> field <*> field  <*> field
instance FromRow Course where  fromRow         = Course <$> field <*> field <*> field  <*> field
instance FromRow AllRegistration where fromRow = AllRegistration <$> field <*> field <*> field <*> field
--instances

-- main and menu options
main :: IO ()
main = do
   putStrLn "\nEnter a number from the menu \n"
   printMenu
   selection <- getLine
   putStrLn ""
   menuSelection selection

printMenu :: IO ()
printMenu = do
   putStrLn "\n ESC[30mMENU SELECTION "
   putStrLn "   For Student :       Enter \ESC[92m1 \ESC[30mfor New Student,  Enter \ESC[92m2 \ESC[30mfor display Students"
   putStrLn "   For Courses :       Enter \ESC[92m3 \ESC[30mfor New Course ,  Enter \ESC[92m4 \ESC[30mfor display Courses"
   putStrLn "   For Registration :  Enter \ESC[92m5 \ESC[30mfor to Register. ,Enter \ESC[92m6 \ESC[30mfor display , and \ESC[92m7 \ESC[30mto delete "
   putStrLn "   To exit          :  Enter \ESC[92m0 \ESC[30mto Exit\n\n"

menuSelection :: String -> IO ()
menuSelection selection
   | selection == "1" = processAddStudent >> main
   | selection == "2" = printStudents >> main  
   | selection == "3" = processAddCourse >> main
   | selection == "4" = printCourses >> main
   | selection == "5" = processAddRegistration >> main  -- registration
   | selection == "6" = printAllRegistration >> main           -- view all egistration
   | selection == "7" = processDeleteRegistration >> main   -- delete registration
   | selection == "0" = print "Program Ends, Bye!!!!!!!"
   | otherwise = print "Selection not found, please try again!!!!!" >> main
-- end of main

{- addStudent :: String -> IO ()
addStudent firstName = do
   conn <- open "project.db"  
   execute conn "INSERT INTO Student (firstName) VALUES (?" (Only firstName)
   r <- query_ conn "SELECT * from Student" :: IO [Student]
   mapM_ print r
   close conn -}

dbConnection :: (Connection -> IO ()) -> IO ()
dbConnection action = do
   conn <- open databaseName
   action conn
   close conn
   
-- Student
processAddStudent :: IO ()
processAddStudent = do
   print "Enter the first Nnme"
   firstName <- getLine
   print "Enter the last name"
   lastName <- getLine
   executeAddUser firstName lastName
   
executeAddUser :: String -> String -> IO ()
executeAddUser first last  = dbConnection $
                           \conn -> do
                             tool <- checkUsers conn first last
                             print ""   
   
checkUsers :: Connection -> String -> String -> IO ()
checkUsers conn first last = do
               resp <- query conn "SELECT * FROM Student where firstName = ? and lastName = ? " (first , last ) :: IO [Student]
               value <- iskNull resp
               if not value then print "Student already exist "
               else 
                  addStudent first last

addStudent :: String ->String -> IO ()
addStudent firstName lastName = dbConnection $
                   \conn -> do
                     execute conn "INSERT INTO student (firstName , lastName) VALUES (?, ?)" ( firstName , lastName)
                     print "student added"

iskNull :: [a] -> IO Bool
iskNull [] = return True 
iskNull xs = return False

printStudents :: IO ()
printStudents = dbConnection $
             \conn ->  do
               resp <- query_ conn "SELECT * FROM Student;" :: IO [Student]
               value <- iskNull resp
               if value then print "No Records found "
               else 
                 mapM_ print resp
-- end of Student processing

getNum :: IO Integer
getNum = readLn

-- process Courses
processAddCourse :: IO ()
processAddCourse = do
   print "Enter the course name"
   name <- getLine
   print "Enter the course Code"
   desc <-  getLine
   print "Enter the Maximum number of students"
   max <-  getNum
   dbConnection $
                     \conn -> do
                       execute conn "INSERT INTO Course (name , code , maxStudent) VALUES (?,?, ?)" (name, desc, max )
                       print "Course added"

printCourses :: IO ()
printCourses = dbConnection $
             \conn ->  do
               resp <- query_ conn "SELECT * FROM Course;" :: IO [Course]
               value <- iskNull resp
               if value then print "No Records found "
               else 
                 mapM_ print resp

-- end of courses 

-- registration
addRegistration :: Int -> Int -> IO ()
addRegistration studentId courseId = dbConnection $
                         \conn -> do
                           execute conn
                             "INSERT INTO registration (student_id,course_id) VALUES (?,?)"
                             (studentId,courseId)

processAddRegistration :: IO ()
processAddRegistration = do
   print "Enter the user id"
   userId <- pure read <*> getLine
   print "Enter the course id "
   toolId <- pure read <*> getLine
   addRegistration userId toolId

printAllRegistration :: IO ()
printAllRegistration = dbConnection $
             \conn ->  do
               resp <- query_ conn "select student.id , student.firstName , student.lastName, course.name from student , course , registration where student.id = registration.student_id and course.id = registration.course_id;" :: IO [AllRegistration]
               mapM_ print resp

processDeleteRegistration :: IO ()
processDeleteRegistration = do
   print "enter the student id"
   studentId <- pure read <*> getLine
   print "enter the course id"
   courseId <- pure read <*> getLine
   deleteRegistration studentId courseId

deleteRegistration :: Int -> Int -> IO ()
deleteRegistration studentId courseId =  dbConnection $
                     \conn -> do
                       execute conn
                         "DELETE FROM Registration WHERE student_id = ? and course_id = ?;" (studentId , courseId)
-- end of registration
