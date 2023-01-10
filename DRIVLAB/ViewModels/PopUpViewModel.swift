//
//  PopUpViewModel.swift
//  DRIVLAB
//
//  Created by David Batista on 04/01/2023.
//

import Foundation


class Global{
    
    static let instance = Global()
    
    var popUpViewModel: PopUpViewModel
    
    var visualizeDetections: Bool = true
    var showLabels: Bool = true
    
    init(){
        popUpViewModel = PopUpViewModel()
    }
}


class PopUpViewModel: ObservableObject{
    @Published var isVisible: Bool = false
    @Published var viewUI = PopUpView(
        title: "You have earned 10 XP!",
        subtitle: "Thanks to your drive, you earned 10XP",
        actionText: "Continue!",
        action: {}
    )
    
    var waitingScreens: Queue<PopUpView> = Queue<PopUpView>()
    
    func queueNextScreen(){
        isVisible = false
        if waitingScreens.isEmpty{
            return
        }
        
        viewUI = waitingScreens.oldest!
        isVisible = true
        waitingScreens.remove()
    }
    
}


extension PopUpView{
    
    static func showLevelUpScreen(level: Int){
        let screen = PopUpView(
            title: "You have reached Level \(level)",
            subtitle: "Congratulations!",
            image: "medal",
            imageOverlay: "\(level)",
            showImage: true,
            actionText: "Let's Go!!",
            action: {
                
            }
        )
        
        ///If there is already a screen shown, Queue this one. Else, show
        if Global.instance.popUpViewModel.isVisible == true {
            Global.instance.popUpViewModel.waitingScreens.add(screen)
        }else{
            Global.instance.popUpViewModel.viewUI = screen
            Global.instance.popUpViewModel.isVisible = true
        }
        
    }
    
    static func showEndDriveScreen(drive: Drive){
        guard drive.gainedXP != nil else {
            return
        }
        let isPositive: Bool = drive.gainedXP! > 0
        let imageAlternative = Int.random(in: 1...4)
        let screen = PopUpView(
            title: isPositive ? "You have gained \(drive.gainedXP!) XP" : "You should reconsidere your driving habits...\nYou Lost \(drive.gainedXP!) XP",
            subtitle: "You have completed a \(String(format: "%.2f Km", drive.distance)) Drive!",
            image: isPositive ? "nice\(imageAlternative)" : "bad1",
            showImage: true,
            actionText: "End Drive",
            action: {
                
            }
        )
        ///If there is already a screen shown, Queue this one. Else, show
        if Global.instance.popUpViewModel.isVisible == true {
            Global.instance.popUpViewModel.waitingScreens.add(screen)
        }else{
            Global.instance.popUpViewModel.viewUI = screen
            Global.instance.popUpViewModel.isVisible = true
        }
        
        
    }
}
