//
//  LeftViewController.swift
//  LGSideMenuControllerDemo
//
import RealmSwift
import Realm
class LeftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
//    private let titlesArray = [StudentDbInfo]()
    var  realm : Realm? = nil
    
    var items : [StudentDbInfo] = [StudentDbInfo]()
    
    @IBOutlet var tblStudents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.tblStudents.contentInset = .zero
        self.tblStudents.sectionHeaderHeight = 0
//        self.tblStudents.backgroundColor = UIColor.blue
//        self.tableView.register(UINib.init(nibName: "StudentTableViewCell", bundle: nil), forCellReuseIdentifier: "StudentTableViewCell")
        let nib = UINib(nibName: "CustomHeaderCell", bundle: nil)
        self.tblStudents.register(nib, forHeaderFooterViewReuseIdentifier: "CustomHeaderCell")
        
        self.tblStudents.delegate = self
        self.tblStudents.dataSource = self
        
        realm = try! Realm()
        
        let lists  =  realm?.objects(StudentDbInfo.self)
        var  i = 0
        
        for _ in lists! {
            items.append(lists![i])
              i = i+1
        }
        self.tblStudents.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
       UIApplication.shared.isStatusBarHidden = false

        self.navigationController?.navigationBar.backgroundColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor( red: 12/255, green: 133/255, blue: 145/255, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - UITableViewDataSource
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCellNew", for: indexPath) as! StudentTableViewCellNew
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //        print("items \(items[indexPath] as! StudentDbInfo)")
      
        let s : StudentDbInfo = items[indexPath.row]
        cell.lb2.text = s.memberName
        cell.lb3.text = s.memberSection
        cell.lb1.text = s.memberUid
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return (indexPath.row == 1 || indexPath.row == 3) ? 22.0 : 44.0
        return 100.0
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
          
        let mainViewController = self.sideMenuController!
        //        let viewController = ProfileVCViewController()
        //        viewController.view.backgroundColor = .white
        //            viewController.title = "Test \(items[indexPath.row])"
            print("item \(self.items.count)")
            let s : StudentDbInfo = self.items[indexPath.row]
             print(s.memberId)
        let storyboard = UIStoryboard(name: "Profilenew", bundle: nil)
        let profileview:ProfileVCViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVCViewController") as! ProfileVCViewController
       
        profileview.member = s
        let navigationController = mainViewController.rootViewController as! NavigationController
        navigationController.pushViewController(profileview, animated: true)
        
        mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderCell") as? CustomHeaderCell
        {
//          headerView.item = viewModel.items[section]
            headerView.section = section
            headerView.lblphone.text = Utility().getPhone()
            return headerView
        }
        return UIView()
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 170
    }
    
    
    
  
    
}
