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
                HStack(spacing: 16) {
                    ZStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .padding(.all, 16)
                    }
                    .background(Color.appMediumGray.opacity(0.5))
                    .clipShape(Circle())
                    VStack(alignment: .leading) {
                        if let email = authenticationService.currentUserSession?.email {
                            Text(email)
                        }
                        Text("blas.hugo.dev@gmail.com")
                            .foregroundStyle(.black)
                            .font(.caption)

                        Text(authenticationService.currentUser?.firstName ?? "Hugo")
                            .bold()
                    }
                }
                .frame(maxWidth: geometry.size.width, maxHeight: 96, alignment: .leading)
                .padding(.horizontal, 16)
                VStack(spacing: 10) {
                    //Spacer()
                    Button {

                    } label: {
                        HStack {
                            Text("Mon compte")
                                .foregroundStyle(.black)
                                .padding(.all, 16)
                            Spacer()
                            ZStack {
                                Image(systemName: "chevron.right")
                                    .padding(.all, 6)
                            }
                            .background(Color.appMediumGray.opacity(0.25))
                            .clipShape(Circle())
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    Button {

                    } label: {
                        HStack {
                            Text("Mon historique de challenges")
                                .foregroundStyle(.black)
                                .padding(.all, 16)
                            Spacer()
                            ZStack {
                                Image(systemName: "chevron.right")
                                    .padding(.all, 6)
                            }
                            .background(Color.appMediumGray.opacity(0.25))
                            .clipShape(Circle())
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
                    .padding(.horizontal, 16)
                    Button {

                    } label: {
                        HStack {
                            Text("Politique de confidentialité")
                                .foregroundStyle(.black)
                                .padding(.all, 16)
                            Spacer()
                            ZStack {
                                Image(systemName: "chevron.right")
                                    .padding(.all, 6)
                            }
                            .background(Color.appMediumGray.opacity(0.25))
                            .clipShape(Circle())
                            .padding(.horizontal, 16)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.size.width, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
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
        .navigationTitle(Text(LocalizedStringKey("profile")))
        .navigationBarTitleDisplayMode(.large)
}
