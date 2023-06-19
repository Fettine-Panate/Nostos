import SwiftUI
import Combine

struct BoxSliderView: View {
    @Binding var magnitude : Double
    @Binding var scale : Double
    var body: some View {
        GeometryReader{ gr in
                    VStack(spacing: 0){
                        HStack{
                            ZStack{
                                if magnitude <= 40{
                                    Color("inactiveGray")
                                } else {
                                    
                                        Color("white")
                                }
                                Button(action: {
                                    if magnitude > 40{
                                        magnitude = magnitude / 2
                                        scale = scale / 0.8
                                    } }, label: {
                                        Text("+")
                                    })
                            }
                        }
                        .frame( height: gr.size.height * 48/100)
                        HStack{
                            Spacer()
                        }
                        .frame(height: gr.size.height * 2/100)
                        HStack{
                            ZStack{
                                if magnitude >= 10000{
                                    Color("inactiveGray")
                                } else {
                                    
                                        Color("white")
                                }
                                Button(action:{
                                    if magnitude < 10000{
                                        magnitude = magnitude * 2
                                        scale = scale * 0.8
                                    }} , label: {
                                        Text("-")
                                    })
                            }
                        }
                        .frame(height: gr.size.height * 48/100)
                    }
                    .cornerRadius(10)
        }
    }
}

struct BoxSliderView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSliderView(magnitude: .constant(30.0), scale: .constant(1))
    }
}
