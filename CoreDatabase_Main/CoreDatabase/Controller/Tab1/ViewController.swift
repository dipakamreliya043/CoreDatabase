//
//  ViewController.swift
//
//  Created by Dipak on 05/08/22.
//

import UIKit
import SDWebImage
import CoreData
import Alamofire

class ViewController: UIViewController {

    //Outlet
    @IBOutlet weak var tblView: UITableView!
    
    var arrHome = [Article]()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblView.register(UINib(nibName: "Story_Cell", bundle: nil), forCellReuseIdentifier: "Story_Cell")
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        if NetworkReachabilityManager()!.isReachable{
            GetApiTesla()
        }else{
            retriveingData()
        }
    }
}

//MARK: Tableview Delegate and Datasource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Story_Cell = tblView.dequeueReusableCell(withIdentifier: "Story_Cell", for: indexPath) as! Story_Cell
        if arrHome.count > 0{
            if let dict = arrHome[indexPath.row] as? Article{
                cell.lbl_Name.text = dict.author
                cell.img_Thumnil.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.img_Thumnil.sd_setImage(with: URL(string: dict.urlToImage ?? defaultImg), placeholderImage: UIImage(named: "placeholder"))
                
                cell.lbl_Date.text = convertDateFormat(inputDate: dict.publishedAt, format: "dd-MMM-yyyy")
                cell.lbl_Time.text = convertDateFormat(inputDate: dict.publishedAt, format: "hh:mm a")
                
                if dict.isLike{
                    cell.btn_Like.setTitle("Liked", for: .normal)
                    cell.btn_Like.backgroundColor = .red
                }else{
                    cell.btn_Like.setTitle("Like", for: .normal)
                    cell.btn_Like.backgroundColor = .blue
                }
                
                cell.btnLikeHandling = {
                    self.likePost(id: dict.id, index: indexPath.row, isLike: !dict.isLike)
                }
                cell.btnDeleteHandling = {
                    self.deleteData(id: dict.id, index: indexPath.row)
                }
            }
        }
        return cell
    }
}

//MARK: Api Call
extension ViewController {
    func GetApiTesla() {
        let apiName = getFinalApi(search: "tesla")
        ServiceManager.callAPI(url: apiName, parameter: nil , isShowLoader: true) { (result) in
            if let dictData = result as? NSDictionary
            {
                if let arrDict = dictData["articles"] as? [[String : Any]] {
                    self.firstTimeRecordDelete()
                    var arrHomes = [Article]()
                    for (_, element) in arrDict.enumerated() {
                        arrHomes.append(Article(fromDictionary: element))
                    }
                    for i in 0..<arrHomes.count {
                        if let dict = arrHomes[i] as? Article{
                            self.insertData(author: dict.author ?? "No Name", newtype: "tesla", title: dict.title ?? "No Title", isLike: false, urlToImage: dict.urlToImage ?? "", publishedAt: dict.publishedAt ?? "")
                        }
                    }
                    self.retriveingData()
                }
                print(dictData)
            }
        } failure: { (error) in
            HIDE_CUSTOM_LOADER()
            showToast(error)
        } connectionFailed: { (error) in
            HIDE_CUSTOM_LOADER()
            showToast(error)
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

//MARK: CRUD Operations
extension ViewController {
    
    //MARK: Insert Data in Coredatabase
    func insertData(author: String, newtype: String, title: String, isLike: Bool, urlToImage: String, publishedAt: String){
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entiyDescription = NSEntityDescription.entity(forEntityName: "NewData", in: context) else { return }
        
        
        let newValue = NSManagedObject(entity: entiyDescription, insertInto: context)
        newValue.setValue(author, forKey: "author")
        newValue.setValue(newtype, forKey: "newtype")
        newValue.setValue(title, forKey: "title")
        newValue.setValue(isLike, forKey: "isLike")
        newValue.setValue(urlToImage, forKey: "urlToImage")
        newValue.setValue(publishedAt, forKey: "publishedAt")
        newValue.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Save")
        } catch {
            print("Not Save")
        }
    }
    
    //MARK: Get All Data from Coredatabase
    func retriveingData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NewData>(entityName: "NewData")
        fetchRequest.predicate = NSPredicate(format: "newtype = %@", "tesla")
        
        do {
            let results = try context.fetch(fetchRequest)
            arrHome = [Article]()
            for i in 0..<results.count {
                let dict = results[i]
                arrHome.append(Article(fromDictionary: ["id": dict.id ?? UUID(), "author": dict.author ?? "", "title": dict.title ?? "", "urlToImage": dict.urlToImage ?? "", "publishedAt": dict.publishedAt ?? "", "isLike": dict.isLike]))
            }
            self.reloadData()
        } catch {
            print("Error")
        }
        
    }
    
    //MARK: Delete Specific Data in Coredatabase
    func deleteData(id: UUID, index: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NewData>(entityName: "NewData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        if let result = try? context.fetch(fetchRequest) {
            context.delete(result.first!)
        }
        do {
            try context.save()
            arrHome.remove(at: index)
            reloadData()
        } catch {
            //Handle error
        }
    }
    
    //MARK: Like and Unlike Specific Data in Coredatabase
    func likePost(id: UUID, index: Int, isLike: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NewData>(entityName: "NewData")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        if let result = try? context.fetch(fetchRequest) {
            if result.count > 0{
                let userData = result.first
                userData!.isLike = isLike
            }
            
            do {
                try context.save()
                self.arrHome[index].isLike = isLike
                self.tblView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            } catch {
                //Handle error
            }
        }
    }
    
    func firstTimeRecordDelete() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NewData>(entityName: "NewData")
        fetchRequest.predicate = NSPredicate(format: "newtype = %@", "tesla")
        
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch {
            //Handle error
        }
    }
}
