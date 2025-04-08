import func SwiftUI.__designTimeSelection

import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Volumes/SSD Mac/Dev/Open Classroom/projet libre/StepUp/StepUp/Screens/ProfileScreen/ProfileScreen.swift", line: 1)
//
//  ProfileScreen.swift
//  StepUp
//
//  Created by Hugo Blas on 21/03/2025.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        __designTimeSelection(GeometryReader { geometry in
            __designTimeSelection(VStack {
                __designTimeSelection(HStack(spacing: __designTimeInteger("#6793_0", fallback: 16)) {
                    __designTimeSelection(ZStack {
                        __designTimeSelection(Image(systemName: __designTimeString("#6793_1", fallback: "person.fill"))
                            .resizable()
                            .frame(width: __designTimeInteger("#6793_2", fallback: 48), height: __designTimeInteger("#6793_3", fallback: 48))
                            .padding(.all, __designTimeInteger("#6793_4", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].arg[0].value.[0]")
                    }
                    .background(__designTimeSelection(Color.appMediumGray.opacity(__designTimeFloat("#6793_5", fallback: 0.5)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].modifier[0].arg[0].value"))
                    .clipShape(__designTimeSelection(Circle(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0].modifier[1].arg[0].value")), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[0]")
                    __designTimeSelection(VStack(alignment: .leading) {
                        if let email = authenticationService.currentUserSession?.email {
                            __designTimeSelection(Text(__designTimeSelection(email, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0].[0].[0].arg[0].value")), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[0].[0].[0]")
                        }
                        __designTimeSelection(Text(__designTimeString("#6793_6", fallback: "blas.hugo.dev@gmail.com"))
                            .foregroundStyle(.black)
                            .font(.caption), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[1]")

                        __designTimeSelection(Text(authenticationService.currentUser?.firstName ?? __designTimeString("#6793_7", fallback: "Hugo"))
                            .bold(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1].arg[1].value.[2]")
                    }, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[1].value.[1]")
                }
                .frame(maxWidth: __designTimeSelection(geometry.size.width, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0].modifier[0].arg[0].value"), maxHeight: __designTimeInteger("#6793_8", fallback: 96), alignment: .leading)
                .padding(.horizontal, __designTimeInteger("#6793_9", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[0]")
                __designTimeSelection(VStack(spacing: __designTimeInteger("#6793_10", fallback: 10)) {
                    //Spacer()
                    __designTimeSelection(Button {

                    } label: {
                        __designTimeSelection(HStack {
                            __designTimeSelection(Text(__designTimeString("#6793_11", fallback: "Mon compte"))
                                .foregroundStyle(.black)
                                .padding(.all, __designTimeInteger("#6793_12", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value.[0]")
                            __designTimeSelection(Spacer(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value.[1]")
                            __designTimeSelection(ZStack {
                                __designTimeSelection(Image(systemName: __designTimeString("#6793_13", fallback: "chevron.right"))
                                    .padding(.all, __designTimeInteger("#6793_14", fallback: 6)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value.[2].arg[0].value.[0]")
                            }
                            .background(__designTimeSelection(Color.appMediumGray.opacity(__designTimeFloat("#6793_15", fallback: 0.25)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value.[2].modifier[0].arg[0].value"))
                            .clipShape(__designTimeSelection(Circle(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value.[2].modifier[1].arg[0].value"))
                            .padding(.horizontal, __designTimeInteger("#6793_16", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0].arg[0].value.[2]")
                        }, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].arg[1].value.[0]")
                    }
                    .frame(maxWidth: __designTimeSelection(UIScreen.main.bounds.size.width, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].modifier[0].arg[0].value"), alignment: .leading)
                    .background(.white)
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#6793_17", fallback: 10)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0].modifier[2].arg[0].value"))
                    .shadow(radius: __designTimeInteger("#6793_18", fallback: 1))
                    .padding(.horizontal, __designTimeInteger("#6793_19", fallback: 16))
                    .padding(.top, __designTimeInteger("#6793_20", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[0]")
                    __designTimeSelection(Button {

                    } label: {
                        __designTimeSelection(HStack {
                            __designTimeSelection(Text(__designTimeString("#6793_21", fallback: "Mon historique de challenges"))
                                .foregroundStyle(.black)
                                .padding(.all, __designTimeInteger("#6793_22", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value.[0]")
                            __designTimeSelection(Spacer(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value.[1]")
                            __designTimeSelection(ZStack {
                                __designTimeSelection(Image(systemName: __designTimeString("#6793_23", fallback: "chevron.right"))
                                    .padding(.all, __designTimeInteger("#6793_24", fallback: 6)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value.[2].arg[0].value.[0]")
                            }
                            .background(__designTimeSelection(Color.appMediumGray.opacity(__designTimeFloat("#6793_25", fallback: 0.25)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value.[2].modifier[0].arg[0].value"))
                            .clipShape(__designTimeSelection(Circle(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value.[2].modifier[1].arg[0].value"))
                            .padding(.horizontal, __designTimeInteger("#6793_26", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0].arg[0].value.[2]")
                        }, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].arg[1].value.[0]")
                    }
                    .frame(maxWidth: __designTimeSelection(UIScreen.main.bounds.size.width, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].modifier[0].arg[0].value"), alignment: .leading)
                    .background(.white)
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#6793_27", fallback: 10)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1].modifier[2].arg[0].value"))
                    .shadow(radius: __designTimeInteger("#6793_28", fallback: 1))
                    .padding(.horizontal, __designTimeInteger("#6793_29", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[1]")
                    __designTimeSelection(Button {

                    } label: {
                        __designTimeSelection(HStack {
                            __designTimeSelection(Text(__designTimeString("#6793_30", fallback: "Politique de confidentialité"))
                                .foregroundStyle(.black)
                                .padding(.all, __designTimeInteger("#6793_31", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value.[0]")
                            __designTimeSelection(Spacer(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value.[1]")
                            __designTimeSelection(ZStack {
                                __designTimeSelection(Image(systemName: __designTimeString("#6793_32", fallback: "chevron.right"))
                                    .padding(.all, __designTimeInteger("#6793_33", fallback: 6)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value.[2].arg[0].value.[0]")
                            }
                            .background(__designTimeSelection(Color.appMediumGray.opacity(__designTimeFloat("#6793_34", fallback: 0.25)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value.[2].modifier[0].arg[0].value"))
                            .clipShape(__designTimeSelection(Circle(), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value.[2].modifier[1].arg[0].value"))
                            .padding(.horizontal, __designTimeInteger("#6793_35", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0].arg[0].value.[2]")
                        }, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].arg[1].value.[0]")
                    }
                    .frame(maxWidth: __designTimeSelection(UIScreen.main.bounds.size.width, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].modifier[0].arg[0].value"), alignment: .leading)
                    .background(.white)
                    .clipShape(__designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#6793_36", fallback: 10)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2].modifier[2].arg[0].value"))
                    .shadow(radius: __designTimeInteger("#6793_37", fallback: 1))
                    .padding(.horizontal, __designTimeInteger("#6793_38", fallback: 16))
                    .padding(.bottom, __designTimeInteger("#6793_39", fallback: 16)), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value.[2]")
                    //Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(__designTimeSelection(Color.appLightGray, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1].modifier[1].arg[0].value")), "#6793.[1].[1].property.[0].[0].arg[0].value.[0].arg[0].value.[1]")
            }
            .frame(height: __designTimeSelection(geometry.size.height, "#6793.[1].[1].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value"), alignment: .top), "#6793.[1].[1].property.[0].[0].arg[0].value.[0]")
        }, "#6793.[1].[1].property.[0].[0]")
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(AuthenticationService())
        .navigationTitle(Text(LocalizedStringKey(__designTimeString("#6793_40", fallback: "profile"))))
        .navigationBarTitleDisplayMode(.large)
}
