import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Index from "./pages/Index";
import NotFound from "./pages/NotFound";
import NotreMission from "./pages/NotreMission";
import NosActivites from "./pages/NosActivites";
import Salles3DImmersives from "./pages/Salles3DImmersives";
import DigitalConsulting from "./pages/DigitalConsulting";
import NosEvenements from "./pages/NosEvenements";
import NousSoutenir from "./pages/NousSoutenir";
import NousContacter from "./pages/NousContacter";
import Inscription from "./pages/Inscription";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Index />} />
          <Route path="/notre-mission" element={<NotreMission />} />
          <Route path="/nos-activites" element={<NosActivites />} />
          <Route path="/salles-3d-immersives" element={<Salles3DImmersives />} />
          <Route path="/digital-consulting" element={<DigitalConsulting />} />
          <Route path="/nos-evenements" element={<NosEvenements />} />
          <Route path="/nous-soutenir" element={<NousSoutenir />} />
          <Route path="/nous-contacter" element={<NousContacter />} />
          <Route path="/inscription" element={<Inscription />} />
          {/* ADD ALL CUSTOM ROUTES ABOVE THE CATCH-ALL "*" ROUTE */}
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
