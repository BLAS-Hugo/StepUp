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
        GeometryReader { geometry in
            VStack {
                HStack(spacing: __designTimeInteger("#6793_0", fallback: 16)) {
                    ZStack {
                        Image(systemName: __designTimeString("#6793_1", fallback: "person.fill"))
                            .resizable()
                            .frame(width: __designTimeInteger("#6793_2", fallback: 48), height: __designTimeInteger("#6793_3", fallback: 48))
                            .padding(.all, __designTimeInteger("#6793_4", fallback: 16))
                    }
                    .background(Color.appMediumGray.opacity(__designTimeFloat("#6793_5", fallback: 0.5)))
                    .clipShape(Circle())
                    VStack(alignment: .leading) {
                        if let email = authenticationService.currentUserSession?.email {
                            Text(email)
                        }
                        Text(__designTimeString("#6793_6", fallback: "blas.hugo.dev@gmail.com"))
                            .foregroundStyle(.black)
                            .font(.caption)

                        Text(authenticationService.currentUser?.firstName ?? __designTimeString("#6793_7", fallback: "Hugo"))
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: __designTimeInteger("#6793_8", fallback: 96), alignment: .leading)
                .padding(.horizontal, __designTimeInteger("#6793_9", fallback: 16))
                VStack(spacing: __designTimeInteger("#6793_10", fallback: 10)) {
                    //Spacer()
                    Button {

                    } label: {
                        HStack {
                            Text(__designTimeString("#6793_11", fallback: "Mon compte"))
                                .foregroundStyle(.black)
                                .padding(.all, __designTimeInteger("#6793_12", fallback: 16))
                            Spacer()
                            ZStack {
                                Image(systemName: __designTimeString("#6793_13", fallback: "chevron.right"))
                                    .padding(.all, __designTimeInteger("#6793_14", fallback: 6))
                            }
                            .background(Color.appMediumGray.opacity(__designTimeFloat("#6793_15", fallback: 0.25)))
                            .clipShape(Circle())
                            .padding(.horizontal, __designTimeInteger("#6793_16", fallback: 16))
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#6793_17", fallback: 10)))
                    .shadow(radius: __designTimeInteger("#6793_18", fallback: 1))
                    .padding(.horizontal, __designTimeInteger("#6793_19", fallback: 16))
                    .padding(.top, __designTimeInteger("#6793_20", fallback: 16))
                    Button {

                    } label: {
                        HStack {
                            Text(__designTimeString("#6793_21", fallback: "Mon historique de challenges"))
                                .foregroundStyle(.black)
                                .padding(.all, __designTimeInteger("#6793_22", fallback: 16))
                            Spacer()
                            ZStack {
                                Image(systemName: __designTimeString("#6793_23", fallback: "chevron.right"))
                                    .padding(.all, __designTimeInteger("#6793_24", fallback: 6))
                            }
                            .background(Color.appMediumGray.opacity(__designTimeFloat("#6793_25", fallback: 0.25)))
                            .clipShape(Circle())
                            .padding(.horizontal, __designTimeInteger("#6793_26", fallback: 16))
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#6793_27", fallback: 10)))
                    .shadow(radius: __designTimeInteger("#6793_28", fallback: 1))
                    .padding(.horizontal, __designTimeInteger("#6793_29", fallback: 16))
                    Button {

                    } label: {
                        HStack {
                            Text(__designTimeString("#6793_30", fallback: "Politique de confidentialité"))
                                .foregroundStyle(.black)
                                .padding(.all, __designTimeInteger("#6793_31", fallback: 16))
                            Spacer()
                            ZStack {
                                Image(systemName: __designTimeString("#6793_32", fallback: "chevron.right"))
                                    .padding(.all, __designTimeInteger("#6793_33", fallback: 6))
                            }
                            .background(Color.appMediumGray.opacity(__designTimeFloat("#6793_34", fallback: 0.25)))
                            .clipShape(Circle())
                            .padding(.horizontal, __designTimeInteger("#6793_35", fallback: 16))
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#6793_36", fallback: 10)))
                    .shadow(radius: __designTimeInteger("#6793_37", fallback: 1))
                    .padding(.horizontal, __designTimeInteger("#6793_38", fallback: 16))
                    .padding(.bottom, __designTimeInteger("#6793_39", fallback: 16))
                    //Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .background(Color.appLightGray)
            }
            .frame(height: geometry.size.height, alignment: .top)
        }
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(AuthenticationService())
        .navigationTitle(Text(LocalizedStringKey(__designTimeString("#6793_40", fallback: "profile"))))
        .navigationBarTitleDisplayMode(.large)
}
