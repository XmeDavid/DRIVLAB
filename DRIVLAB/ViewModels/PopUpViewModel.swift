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
        
        let screen = PopUpView(
            title: "You have gained \(drive.gainedXP!) XP",
            subtitle: "You have completed a \(drive.distance)Km Drive!",
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
