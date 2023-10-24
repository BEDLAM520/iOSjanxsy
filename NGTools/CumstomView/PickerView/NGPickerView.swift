//
//  NGPickerView.swift
//

import UIKit

let PickerLoadTimes = ["0","1","2","3","4","5"]

let UserBusinesses = [
    "1":"餐饮／酒店／旅游／美容美发保健",
    "2":"农业／林业／畜牧业和渔业",
    "3":"建筑／装修",
    "4":"文化／运动／娱乐／传媒／广告设计",
    "5":"教育",
    "6":"金融机构／专业性事务机构",
    "7":"政府机构／社会团体",
    "8":"计算机／电信／通讯／互联网",
    "9":"制造／快速消费品／耐用消费品",
    "10":"军队",
    "11":"能源／化工／矿产",
    "12":"电力／煤气／水的生产和供应",
    "13":"个体／自营／退休／居住／家政和其他服务",
    "14":"房地产",
    "15":"科研／技术服务／地质勘探",
    "16":"事业单位／公共设施／医疗卫生／社会保障和社会福利业",
    "17":"交通／运输／仓储／邮电／物流”、“批发和零售贸易",
    "18":"批发和零售贸易",
    "19":"其它",
]

enum NGPickerType{
    case Default
    case City
    case LoanTime
    case Business
}

class NGPickerView: UIView {
    
    @IBOutlet weak var pickerView: UIPickerView!
    fileprivate var firstTableDataArray = [String]()
    fileprivate var secondTableDataArray = [String]()
    fileprivate var citiesCodes = [String]()
    public var cityCode:String?
    public var businessCode:String?
    
    fileprivate var type = NGPickerType.Default
    public var pickerType:NGPickerType? {
        didSet{
            if let pickerType = pickerType {
                type = pickerType
                loadData()
            }
        }
    }
    
    class func nibView()->NGPickerView{
        return Bundle.main.loadNibNamed("NGPickerView", owner: self, options: nil)?.last as! (NGPickerView)
    }
    
}


extension NGPickerView:UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch type {
        case .LoanTime, .Business:
            return 1
        case .City:
            return 2
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch type {
        case .LoanTime, .Business:
            return firstTableDataArray.count
        case .City:
            if component == 0{
                return firstTableDataArray.count
            }else if component == 1 {
                return secondTableDataArray.count
            }
        default:
            return 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch type {
        case .LoanTime, .Business:
            return firstTableDataArray[row]
        case .City:
            if component == 0{
                return firstTableDataArray[row]
            }else if component == 1 {
                return secondTableDataArray[row]
            }
        default:
            return nil
        }
        return nil
    }
    
    
    //自定义pickerview列表显示效果
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLbl = view as? UILabel
        if view == nil {
            pickerLbl = UILabel()
            pickerLbl?.backgroundColor = .clear
            pickerLbl?.font = UIFont.systemFont(ofSize: 17)
            pickerLbl?.textColor = .black
            pickerLbl?.textAlignment = .center
        }
        pickerLbl?.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
//        pickerView.clearSpearatorLine()
        return pickerLbl!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch type {
        case .City:
            if component == 0{
                resetCities()
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
            }
        default:
            break
        }
        
    }
}


extension NGPickerView{
    public func getTitle()->String?{
        switch type {
        case .LoanTime:
            return firstTableDataArray[pickerView.selectedRow(inComponent: 0)]
        case .Business:
            businessCode = Array(UserBusinesses.keys)[pickerView.selectedRow(inComponent: 0)]
            return firstTableDataArray[pickerView.selectedRow(inComponent: 0)]
        case .City:
            cityCode = citiesCodes[pickerView.selectedRow(inComponent: 1)]
            return firstTableDataArray[pickerView.selectedRow(inComponent: 0)] + " "
                + secondTableDataArray[pickerView.selectedRow(inComponent: 1)]
        default:
            return nil
        }
        
    }
    
    //TODO:转模型
    fileprivate func loadData(){
//        switch type {
//        case .LoanTime:
//            firstTableDataArray = PickerLoadTimes
//        case .Business:
//            firstTableDataArray = Array(UserBusinesses.values)
//        case .City:
//            firstTableDataArray = Array(provinceDict!.keys)
//            resetCities()
//        default:
//            break
//        }
    }
    
    fileprivate func resetCities(){
//        let cities = provinceDict![firstTableDataArray[pickerView.selectedRow(inComponent: 0)]] as! [[String: String]]
//        var tempArray = [String]()
//        var tempCodes = [String]()
//        for dict in cities {
//            tempArray.append(dict["name"]!)
//            tempCodes.append(dict["code"]!)
//        }
//        secondTableDataArray = tempArray
    }
}


