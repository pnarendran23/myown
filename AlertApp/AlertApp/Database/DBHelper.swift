//
//  DBHelper.swift
//  Placer For Schools
//
//  Created by Group10 on 01/02/18.
//  Copyright © 2015 Group10. All rights reserved.
//

let sharedInstance = DBHelper()

class DBHelper: NSObject
{
    var database: FMDatabase? = nil
    
    override init()
    {
        super.init()
    }
    
    class func getInstance() -> DBHelper
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: DBHelper().getPath(fileName: "PFS.sqlite"))
        }
        return sharedInstance
    }
    
    
    func addStudentData(student: Student) -> Bool
    {
        sharedInstance.database!.open()
       
        print("Student id check for ",(student.studentId))
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Students where studentId = ?", withArgumentsIn: [student.studentId])
  
        resultSet.next()
        print("DB have nil values for \(student.studentId) = ",resultSet.string(forColumnIndex: 0) == nil)
        
        if resultSet.columnIndexIsNull(0)
        {
            var tripid:String? = nil
            var pplat:String? = nil
            var pplng:String? = nil
            var pploc:String? = nil
            var routename:String? = nil
            var pickup_start:String? = nil
            var pickup_end:String? = nil
            var drop_start:String? = nil
            var drop_end:String? = nil
            if let _  = student.tripId as String!
            {
                tripid = student.tripId as String!
            }
                if let _  = student.ppLat as String!
                {
                    pplat = student.ppLat as String!
                }
                if let _  = student.ppLng as String!
                {
                    pplng = student.ppLng as String!
                }
                if let _  = student.ppLocationName as String!
                {
                    pploc = student.ppLocationName as String!
                }
                if let _  = student.routeName as String!
                {
                    routename = student.routeName as String!
                }
                if let _  = student.pickup_start as String!
                {
                    pickup_start = student.pickup_start as String!
                }
                if let _  = student.pickup_end as String!
                {
                    pickup_end = student.pickup_end as String!
                }
                if let _  = student.drop_start as String!
                {
                    drop_start = student.drop_start as String!
                }
                if let _  = student.drop_end as String!
                {
                    drop_end = student.drop_end as String!
                }
            let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Students (studentId, studentName, studentClass, vehName, orgId , orgName , ppLat , ppLng , ppLocationName , routeName , timeTillNextTrip , tripId , pickup_start , pickup_end, drop_start, drop_end) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsIn: [
                    student.studentId as String,
                    student.studentName as String,
                    student.studentClass as String,
                    student.vehName == nil ? NSNull():student.vehName! as String,
                    student.orgId as String,
                    student.orgName as String,
                    pplat == nil ? NSNull():pplat!,
                    pplng == nil ? NSNull():pplng!,
                    pploc == nil ? NSNull():pploc!,
                    routename == nil ? NSNull():routename!,
                    student.timeTillNextTrip as Int,
                    tripid == nil ? NSNull():tripid!,
                    pickup_start == nil ? NSNull():pickup_start!,
                    pickup_end == nil ? NSNull():pickup_end!,
                    drop_start == nil ? NSNull():drop_start!,
                    drop_end == nil ? NSNull():drop_end!])
                    //print("tripId in db ")
                    //print(tripid == nil ? NSNull():tripid!)
                    sharedInstance.database!.close()
                    //print("isInserted is ",isInserted)
                    return isInserted
        }
        else
        {
            print("Gonna update students data")
            sharedInstance.database!.close()
            return updateStudentData(student: student,resultSet:resultSet)
        }
    }
    
    func insesrtStudent() {
        
    }
    
    func updateStudentData(student: Student,resultSet:FMResultSet!) -> Bool
    {
        sharedInstance.database!.open()
        print(resultSet.columnCount())
        
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Students SET ppLat=?, ppLng=?, vehName = ?, ppLocationName=?,routeName=?, tripId = ?,pickup_start = ?,pickup_end = ?,drop_start=?,drop_end=? WHERE studentId=?", withArgumentsIn: [
            student.ppLat as String!,
            student.ppLng as String!,
            student.vehName == nil ? (resultSet.columnIndexIsNull(15) ?nil :resultSet.string(forColumnIndex: 15)):student.vehName! as String,
            student.ppLocationName as String!,
            student.routeName as String!,
            student.tripId == nil ? (resultSet.columnIndexIsNull(10) ? nil :resultSet?.string(forColumnIndex: 10)):student.tripId! as String,
            student.pickup_start == nil ? (resultSet.columnIndexIsNull(11) ? nil :resultSet
                .string(forColumnIndex: 11)):student.pickup_start! as String,
            student.pickup_end == nil ? (resultSet.columnIndexIsNull(12) ? nil :resultSet
                .string(forColumnIndex: 12)):student.pickup_end! as String,
            student.drop_start == nil ? (resultSet.columnIndexIsNull(13) ? nil :resultSet
                .string(forColumnIndex: 13)):student.drop_start! as String,
            student.drop_end == nil ? (resultSet.columnIndexIsNull(14) ? nil :resultSet
                .string(forColumnIndex: 14)):student.drop_end! as String,
            student.studentId as String])
        sharedInstance.database!.close()
         print("isUpdated is ",isUpdated)
        return isUpdated
    }
    
    func deleteStudentData(student: Student) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Students WHERE studentId=?", withArgumentsIn: [student.studentId])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func getAllStudentData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Students", withArgumentsIn: nil)
        let students : NSMutableArray = NSMutableArray()
        if (resultSet != nil)
        {
          while resultSet.next()
          {
            let student : Student = Student()
            student.studentId = resultSet.string(forColumn: "studentId")
            student.studentName = resultSet.string(forColumn: "studentName")
            student.studentClass = resultSet.string(forColumn: "studentClass")
            student.orgId = resultSet.string(forColumn: "orgId")
            student.orgName = resultSet.string(forColumn: "orgName")
            student.routeName = resultSet.string(forColumn: "routeName")
            student.tripId = resultSet.string(forColumn: "tripId")
            student.ppLat = resultSet.string(forColumn: "ppLat")
            student.ppLng = resultSet.string(forColumn: "ppLng")
            student.ppLocationName = resultSet.string(forColumn: "ppLocationName")
            student.pickup_start = resultSet.string(forColumn: "pickup_start")
            student.pickup_end = resultSet.string(forColumn: "pickup_end")
            student.drop_start = resultSet.string(forColumn: "drop_start")
            student.drop_end = resultSet.string(forColumn: "drop_end")
            student.vehName = resultSet.string(forColumn: "vehName")
            students.add(student)
          }
        }
        sharedInstance.database!.close()
        return students
    }
    
    func getOrgName(studentId:String) -> String
    {
        var org:String = ""
        print(studentId)
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Students", withArgumentsIn: nil)
        if (resultSet != nil)
        {
            while resultSet.next()
            {
                if resultSet.string(forColumn: "studentId") == studentId
             {
                org = resultSet.string(forColumn: "orgName")
             }
            }
        }
        print("5")
        sharedInstance.database!.close()
        print("org = \(org)")
        return org
    }
    
    func addMessage(orgName:String,studentId:String, message:String, readOrUnread:String, studentName:String, serverTime:String) -> Bool
    {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Messages (orgName, studentId, message, readOrUnread, studentName, server_time) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsIn: [
            orgName,
            studentId,
            message,
            readOrUnread,
            studentName,
            serverTime])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func updateAllMessagesAsRead() -> Bool
    {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Messages SET readOrUnread=?", withArgumentsIn: [
            "r"])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func unreadMessagesCount() -> Int
    {
        sharedInstance.database!.open()
        let resultSet = sharedInstance.database!.executeQuery("Select count(*) from Messages where readOrUnread=?", withArgumentsIn: [
            "u"])
        
        var count : Int32 = 0
        if (resultSet != nil)
        {
            count = resultSet!.int(forColumnIndex: 0)
        }
        sharedInstance.database!.close()
        return Int(count)
    }
    
    func unreadAlertsCount() -> Int
    {
        sharedInstance.database!.open()
        let resultSet = sharedInstance.database!.executeQuery("Select count(*) from Alert where readOrUnread=?", withArgumentsIn: [
            "u"])
        
        var count = 0
        if (resultSet != nil)
        {
            count = Int(resultSet!.int(forColumnIndex: 0))
        }
        sharedInstance.database!.close()
        return count
    }
    
    func deleteMessages(messagesId: String) -> Bool
    {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Messages WHERE messagesId=?", withArgumentsIn: [messagesId])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func getAllMessages() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Messages", withArgumentsIn: nil)
        let messages : NSMutableArray = NSMutableArray()
        if (resultSet != nil)
        {
            while resultSet.next()
            {
                let message : Message = Message()
                message.messagesId = resultSet.string(forColumn: "messagesId")
                message.studentId = resultSet.string(forColumn: "studentId")
                message.studentName = resultSet.string(forColumn: "studentName")
                message.serverTime = resultSet.string(forColumn: "server_time")
                message.receivedTime = resultSet.string(forColumn: "received_time")
                message.orgName = resultSet.string(forColumn: "orgName")
                message.readOrUnread = resultSet.string(forColumn: "readOrUnread") as String
                message.message = resultSet.string(forColumn: "message")
                messages.add(message)
            }
        }
        sharedInstance.database!.close()
        return messages
    }

    func addAlert(orgName:String,studentId:String, alert:String, readOrUnread:String, studentName:String, serverTime:String) -> Bool
    {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Alert (orgName, studentId, alert, readOrUnread, studentName, server_time) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsIn: [
            orgName,
            studentId,
            alert,
            readOrUnread,
            studentName,
            serverTime])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func getAllAlarmDetails(studentId:String, tripType:String) -> NSMutableArray {
        sharedInstance.database!.open()
//        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM AlarmRingDetails", withArgumentsInArray: nil)
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM AlarmRingDetails where studentId = ? AND tripType = ? order by date", withArgumentsIn: [studentId,tripType])
        let alarmDetails : NSMutableArray = NSMutableArray()
        if (resultSet != nil)
        {
            while resultSet.next()
            {
                let alarmDetail : AlarmDetails = AlarmDetails()
                alarmDetail.studentId = resultSet.string(forColumn: "studentId")
                alarmDetail.studentName = resultSet.string(forColumn: "studentName")
                alarmDetail.time = resultSet.string(forColumn: "time")
                print("TIME from DB = %@",resultSet.string(forColumn: "time"))
                alarmDetail.date = resultSet.string(forColumn: "date")
                print("DATE from DB = %@",resultSet.string(forColumn: "date"))
                alarmDetail.tripType = resultSet.string(forColumn: "tripType")
                alarmDetails.add(alarmDetail)
            }
        }
        sharedInstance.database!.close()
        return alarmDetails
    }

    func addAlarmDetails(studentId:String,studentName:String, time:String, date:String, tripType:String) -> Bool
    {
        print("Alram time\(time) and date\(date) in DBHelper class")
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM AlarmRingDetails where studentId = ? AND tripType = ?", withArgumentsIn: [studentId,tripType])
        resultSet.next()
        var count = 0
        var timeDel = ""
        var dateDel = ""
        while resultSet.hasAnotherRow()
        {
            if count == 0
            {
                timeDel = resultSet.string(forColumn: "time")
                dateDel = resultSet.string(forColumn: "date")
            }
            count += 1;
            resultSet.next()
        }
//        print("Alarm Details Count for \(resultSet.stringForColumn("studentName")) is \(count)")
        if count >= 7
        {
            sharedInstance.database!.executeQuery("DELETE * FROM AlarmRingDetails where time = ? AND date = ?",withArgumentsIn: [timeDel, dateDel])
        }

        
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO AlarmRingDetails (studentId, studentName, time, tripType, date) VALUES (?, ?, ?, ?, ?)", withArgumentsIn: [
            studentId,
            studentName,
            time,
            tripType,date])
        sharedInstance.database!.close()
        return isInserted
    }

    
    func updateAllAlertsAsRead() -> Bool
    {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE Alert SET readOrUnread=?", withArgumentsIn: [
            "r"])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func deleteAlerts(alertsId: String) -> Bool
    {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Alert WHERE alertsId=?", withArgumentsIn: [alertsId])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func unRegister()
    {
        sharedInstance.database!.open()
        sharedInstance.database!.executeUpdate("DELETE FROM Alert", withArgumentsIn: nil)
        sharedInstance.database!.executeUpdate("DELETE FROM Messages", withArgumentsIn: nil)
        sharedInstance.database!.executeUpdate("DELETE FROM Students", withArgumentsIn: nil)
        sharedInstance.database!.executeUpdate("DELETE FROM AlarmRingDetails", withArgumentsIn: nil)
        sharedInstance.database!.close()
    }
    
    func deleteAlaramDetails()
    {
        sharedInstance.database!.open()
       
        sharedInstance.database!.executeUpdate("DELETE FROM AlarmRingDetails", withArgumentsIn: nil)
        sharedInstance.database!.close()
    }
    
    func getAllAlerts() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Alert", withArgumentsIn: nil)
        let alerts : NSMutableArray = NSMutableArray()
        if (resultSet != nil)
        {
            while resultSet.next()
            {
                let alert : Alert = Alert()
                alert.alertsId = resultSet.string(forColumn: "alertsId")
                alert.studentId = resultSet.string(forColumn: "studentId")
                alert.studentName = resultSet.string(forColumn: "studentName")
                alert.serverTime = resultSet.string(forColumn: "server_time")
                alert.receivedTime = resultSet.string(forColumn: "received_time")
                alert.orgName = resultSet.string(forColumn: "orgName")
                alert.readOrUnread = resultSet.string(forColumn: "readOrUnread") as String
                alert.alert = resultSet.string(forColumn: "alert")
                alerts.add(alert)
            }
        }
        sharedInstance.database!.close()
        return alerts
    }
    func getPath(fileName: String) -> String {
    
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        print("dbPath = "+fileURL.path)
        return fileURL.path
    }
}
