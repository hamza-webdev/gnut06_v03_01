import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Card, CardContent } from '@/components/ui/card';
import { 
  Search, 
  Target, 
  Rocket, 
  Star,
  ChevronDown
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";

const DigitalConsulting = () => {
  const services = [
    {
      icon: Search,
      title: "Audit Numérique",
      description: "On commence par évaluer et on analyse votre infrastructure actuelle et on identifie les zones d'amélioration et systèmes de gestion."
    },
    {
      icon: Target,
      title: "Stratégie Numérique", 
      description: "On constitue sur un plan stratégique cyber destiné à dynamiser votre entreprise. Nous identifions les canaux de communication plus optimaux."
    },
    {
      icon: Rocket,
      title: "Conception et Mise en Œuvre",
      description: "On crée votre solution numérique en utilisant des technologies avancées pour créer une expérience de navigation unique pour votre audience."
    }
  ];

  const testimonials = [
    {
      text: "Grâce à Gnut 06, j'ai pu intégrer la réalité virtuelle professionnellement et développer mes compétences en réalité virtuelle. Leur expertise et leur engagement pour l'inclusion sont exceptionnels.",
      author: "Sylvie Alexandre",
      role: "Psychologue UE Gériat"
    },
    {
      text: "Les services de Gnut 06 ont transformé notre approche numérique. Leur expertise et leur engagement pour l'inclusion sont exceptionnels.",
      author: "Pierre Marseille",
      role: "Créateur d'applications"
    },
    {
      text: "Nous avons eu une intégration significative de notre site web et de notre présence en ligne grâce à l'audit numérique de Gnut06. Je recommande vivement leurs services.",
      author: "Stella François", 
      role: "Porteur Projetl"
    }
  ];

  const faqItems = [
    {
      question: "Pourquoi engager un consultant plutôt que de le faire en interne ?",
      answer: "Un consultant offre une expertise spécialisée et une expérience approfondie. Il n'est pas lié à la structure sur les moyens existants et apporte fraîcheur des solutions que votre équipe n'aurait pas envisagée."
    },
    {
      question: "Quels types de livrables peut-on attendre ?",
      answer: "Cela varie en consultation. Cela peut inclure des modèles stratégiques, développées selon vos spécifications et optimisations pour l'accessibilité. L'amélioration se continue. Processus attentions ainsi niveaux d'ébat."
    },
    {
      question: "Combien de temps le projet prendra-t-il avant de mesurer les résultats ?",
      answer: "• Petits projets (sites web simples) : 2 à 4 semaines\n• Projets moyens (applications mobiles) : 2 à 6 mois\n• Grands projets : Quatre semaines avec stratégiques"
    }
  ];

  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="pt-20">
        {/* Hero Section */}
        <section className="relative py-24 overflow-hidden">
          <div className="absolute inset-0 bg-gradient-radial from-primary/10 via-transparent to-transparent"></div>
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid lg:grid-cols-2 gap-12 items-center">
              <div className="space-y-8">
                <h1 className="text-4xl lg:text-6xl font-bold">
                  <span className="text-gradient">Digital Consulting</span>
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                  Gnut 06 aide les personnes en situation de handicap à s'intégrer au monde professionnel grâce à des technologies comme l'IA/RV/RA.
                </p>
                <div className="space-y-4">
                  <p className="text-muted-foreground">
                    Nous proposons des services variés, allant de la gestion 
                    administrative à la création de métaverses, tout en mettant 
                    l'accent sur l'accessibilité. Notre impact social est 
                    soutenu par des témoignages de réussite et reconnaissance par 
                    des instituts spécialisés.
                  </p>
                </div>
              </div>
              <div className="relative">
                <div className="bg-gradient-to-br from-primary/20 to-purple-600/20 rounded-2xl p-8">
                  <img 
                    src="https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=500&h=400&fit=crop" 
                    alt="Digital Consulting avec IA"
                    className="w-full h-64 object-cover rounded-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Services Section */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">
              Nos Services de Consultation Numérique
            </h2>
            
            <div className="grid md:grid-cols-3 gap-8">
              {services.map((service, index) => (
                <Card key={index} className="bg-card border-border hover:shadow-lg transition-shadow">
                  <CardContent className="p-8 text-center">
                    <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                      <service.icon className="w-8 h-8 text-primary" />
                    </div>
                    <h3 className="text-xl font-bold mb-4">{service.title}</h3>
                    <p className="text-muted-foreground">{service.description}</p>
                    <img 
                      src={`https://images.unsplash.com/photo-${index === 0 ? '1518770660439-4636190af475' : index === 1 ? '1526374965328-7f61d4dc18c5' : '1605810230434-7631ac76ec81'}?w=300&h=200&fit=crop`}
                      alt={service.title}
                      className="w-full h-32 object-cover rounded-lg mt-6"
                    />
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* Testimonials */}
        <section className="py-20 bg-card/50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">
              Nos Clients témoignent
            </h2>
            <p className="text-center text-muted-foreground mb-12">
              Découvrez ce que nos clients pensent de notre consultation numérique.
            </p>
            
            <div className="grid md:grid-cols-3 gap-8">
              {testimonials.map((testimonial, index) => (
                <Card key={index} className="bg-card border-border">
                  <CardContent className="p-6">
                    <div className="flex mb-4">
                      {[...Array(5)].map((_, i) => (
                        <Star key={i} className="w-5 h-5 text-yellow-400 fill-current" />
                      ))}
                    </div>
                    <p className="text-muted-foreground mb-4 italic">
                      "{testimonial.text}"
                    </p>
                    <div>
                      <p className="font-medium">{testimonial.author}</p>
                      <p className="text-sm text-muted-foreground">{testimonial.role}</p>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </section>

        {/* FAQ Section */}
        <section className="py-20">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <h2 className="text-3xl lg:text-4xl font-bold text-center mb-16">FAQ</h2>
            <p className="text-center text-muted-foreground mb-12">
              Découvrez les réponses aux questions les plus fréquentes.
            </p>

            <Accordion type="single" collapsible className="space-y-4">
              {faqItems.map((item, index) => (
                <AccordionItem key={index} value={`item-${index}`} className="bg-card border border-border rounded-lg px-6">
                  <AccordionTrigger className="text-left">
                    <span className="font-medium">{item.question}</span>
                  </AccordionTrigger>
                  <AccordionContent className="text-muted-foreground">
                    {item.answer.split('\n').map((line, i) => (
                      <p key={i} className={i > 0 ? 'mt-2' : ''}>{line}</p>
                    ))}
                  </AccordionContent>
                </AccordionItem>
              ))}
            </Accordion>

            <div className="text-center mt-12">
              <h3 className="text-xl font-bold mb-4">Des questions supplémentaires ?</h3>
              <h3 className="text-xl font-bold mb-4">Besoin d'un devis ?</h3>
              <p className="text-muted-foreground mb-6">
                N'hésitez pas à nous contacter pour plus d'informations ou très 
                pour planifier une consultation.
              </p>
              <Button className="btn-tech">
                Nous contacter
              </Button>
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default DigitalConsulting;