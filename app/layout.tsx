import type { Metadata } from "next";
import "./globals.css";
export const metadata:Metadata={title:"PennyWise AI — See the future of your money",description:"Open-weight AI purchase-decision assistant with verified cash-flow scenarios for Nigerian students."};
export default function Layout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}
