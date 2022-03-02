//
//  PullToRefresh.swift
//  Components
//
//  Created by Alexandra Vychytil on 02.03.22.
//
import SwiftUI

public enum PullToRefreshState{
    case wating
    case pulled
    case finishing
}


@available(macOS 13.0, *)
public struct PullToRefresh: View {
    // MARK: Attributes
    @State var needRefresh: PullToRefreshState = .wating
    var coordinateSpaceName: String
    var onRefresh: () -> Void
    var canReload: Bool
    private let midY = 80.0
    private let maxY = 20.0
    private let delay = 0.5
    private let on = 1.0
    private let off = 0.0
    
    
    public init(coordinateSpaceName: String, onRefresh: @escaping () -> Void, canReload: Bool){
        self.coordinateSpaceName = coordinateSpaceName
        self.onRefresh = onRefresh
        self.canReload = canReload
    }
    
   public var body: some View {
        GeometryReader{ geo in
            if(geo.frame(in: .named(coordinateSpaceName)).midY > self.midY){
                Spacer()
                    .onAppear {
                        DispatchQueue.main.async {
                            self.needRefresh = .pulled
                        }
                    }
            }else if(geo.frame(in: .named(coordinateSpaceName)).maxX < self.maxY){
                Spacer()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.delay){
                            if self.needRefresh == .pulled{
                                self.needRefresh = .finishing
                                if self.canReload{
                                    self.onRefresh()
                                }
                            }
                        }
                    }
            }
            HStack{
                Spacer()
                if self.needRefresh == .pulled{
                    ProgressView()
                }
                Spacer()
            }.opacity(self.needRefresh != .wating ? on: off)
                .padding(.top, -50)
                .frame(height: 0)
        }
    }
}




