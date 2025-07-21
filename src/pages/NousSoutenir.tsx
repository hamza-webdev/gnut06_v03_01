import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Heart, Target, Users, Lightbulb } from 'lucide-react';

const NousSoutenir = () => {
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
                  <span className="text-gradient">Ensemble, Construisons un Monde Inclusif !</span>
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                  Chers amis de l'association GNUT 06,
                  Nous avons besoin de votre soutien pour continuer à aider 
                  les personnes en situation de handicap. Notre mission est 
                  d'encourager l'inclusion et le maintien dans l'emploi, malgré 
                  les obstacles.
                </p>
              </div>
              <div className="relative">
                <div className="bg-gradient-to-br from-primary/20 to-purple-600/20 rounded-2xl p-8">
                  <img 
                    src="https://images.unsplash.com/photo-1523712999610-f77fbcfc3843?w=500&h=400&fit=crop" 
                    alt="Solidarité et soutien"
                    className="w-full h-64 object-cover rounded-lg"
                  />
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Why Support Section */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center mb-16">
              <Heart className="w-12 h-12 text-primary mr-4" />
              <h2 className="text-3xl lg:text-4xl font-bold">
                Pourquoi donner à GNUT06 ?
              </h2>
            </div>
            
            <div className="grid md:grid-cols-3 gap-8">
              <Card className="bg-card border-border">
                <CardContent className="p-8">
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                    <Target className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-bold mb-4">Impact immédiat</h3>
                  <p className="text-muted-foreground">
                    Chaque don, peu importe son montant, change la vie de nos bénéficiaires en finançant des formations et des opportunités d'emploi.
                  </p>
                </CardContent>
              </Card>

              <Card className="bg-card border-border">
                <CardContent className="p-8">
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                    <Lightbulb className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-bold mb-4">Technologies innovantes</h3>
                  <p className="text-muted-foreground">
                    Grâce à la réalité virtuelle, nous offrons des expériences uniques. Votre don crée ces moments magiques.
                  </p>
                </CardContent>
              </Card>

              <Card className="bg-card border-border">
                <CardContent className="p-8">
                  <div className="inline-flex items-center justify-center w-16 h-16 bg-primary/10 rounded-full mb-6">
                    <Users className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-bold mb-4">Solidarité</h3>
                  <p className="text-muted-foreground">
                    En soutenant GNUT 06, vous rejoignez une communauté pour un monde inclusif. Chaque euro compte !
                  </p>
                </CardContent>
              </Card>
            </div>
          </div>
        </section>

        {/* Donation Form Section */}
        <section className="py-20 bg-card/50">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="bg-white rounded-2xl shadow-xl overflow-hidden">
              {/* Header */}
              <div className="bg-gradient-to-r from-purple-600 to-blue-600 p-6 text-white">
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center mr-4">
                      <Heart className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="text-xl font-bold">Faire un don</h3>
                      <p className="text-sm opacity-90">au profit de Gnut 06</p>
                    </div>
                  </div>
                  <div className="flex space-x-2">
                    <div className="w-8 h-6 bg-blue-500 rounded flex items-center justify-center text-xs font-bold">FR</div>
                    <div className="w-8 h-6 bg-red-500 rounded flex items-center justify-center text-xs font-bold">EN</div>
                  </div>
                </div>
              </div>

              {/* Form Content */}
              <div className="p-8 text-black">
                <div className="grid md:grid-cols-2 gap-8">
                  {/* Left Column */}
                  <div>
                    <h4 className="font-bold text-lg mb-4">💜 Mon don</h4>
                    
                    {/* Amount Selection */}
                    <div className="space-y-3 mb-6">
                      <div className="grid grid-cols-4 gap-2">
                        <button className="border-2 border-purple-600 bg-purple-600 text-white rounded px-3 py-2 text-sm font-medium">30 €</button>
                        <button className="border-2 border-gray-300 rounded px-3 py-2 text-sm">50 €</button>
                        <button className="border-2 border-gray-300 rounded px-3 py-2 text-sm">100 €</button>
                        <button className="border-2 border-gray-300 rounded px-3 py-2 text-sm">150 €</button>
                      </div>
                      <div className="flex items-center space-x-2">
                        <span className="text-sm">Montant libre</span>
                        <input type="number" className="border border-gray-300 rounded px-2 py-1 text-sm w-20" />
                      </div>
                    </div>

                    <div className="space-y-3 text-sm text-gray-600">
                      <label className="flex items-center">
                        <input type="radio" name="frequency" className="mr-2" defaultChecked />
                        Je donne une fois
                      </label>
                      <label className="flex items-center">
                        <input type="radio" name="frequency" className="mr-2" />
                        Je donne tous les mois
                      </label>
                    </div>

                    <p className="text-xs text-gray-500 mt-4">
                      Payer en tant qu'organisme *. Pour cette ca compte Helloasso, le me concerné
                    </p>

                    {/* Contact Form */}
                    <div className="mt-6 space-y-4">
                      <div className="grid grid-cols-2 gap-3">
                        <input type="text" placeholder="Prénom *" className="border border-gray-300 rounded px-3 py-2 text-sm" />
                        <input type="text" placeholder="Nom *" className="border border-gray-300 rounded px-3 py-2 text-sm" />
                      </div>
                      <input type="email" placeholder="Email *" className="w-full border border-gray-300 rounded px-3 py-2 text-sm" />
                      <input type="email" placeholder="Confirmation Email *" className="w-full border border-gray-300 rounded px-3 py-2 text-sm" />
                      <input type="text" placeholder="Date de naissance *" className="w-full border border-gray-300 rounded px-3 py-2 text-sm" />
                      <input type="text" placeholder="Adresse *" className="w-full border border-gray-300 rounded px-3 py-2 text-sm" />
                      <div className="grid grid-cols-2 gap-3">
                        <input type="text" placeholder="Code postal *" className="border border-gray-300 rounded px-3 py-2 text-sm" />
                        <input type="text" placeholder="Ville *" className="border border-gray-300 rounded px-3 py-2 text-sm" />
                      </div>
                      <select className="w-full border border-gray-300 rounded px-3 py-2 text-sm">
                        <option>France</option>
                      </select>
                    </div>
                  </div>

                  {/* Right Column */}
                  <div>
                    <h4 className="font-bold text-lg mb-4">🧾 Mes coordonnées</h4>
                    
                    <div className="bg-purple-50 rounded-lg p-4 mb-6">
                      <div className="space-y-2 text-sm">
                        <div className="flex justify-between">
                          <span>Don</span>
                          <span>30 €</span>
                        </div>
                        <div className="flex justify-between">
                          <span>Frais HelloAsso</span>
                          <span>0 €</span>
                        </div>
                        <div className="flex justify-between">
                          <span>Pourboire</span>
                          <span>0 €</span>
                        </div>
                        <hr className="my-2" />
                        <div className="flex justify-between font-bold">
                          <span>Total</span>
                          <span>30 €</span>
                        </div>
                      </div>
                    </div>

                    <div className="text-sm space-y-3">
                      <p>Tel/AdAsso est une entreprise sociale et solidaire, qui fournit gracieusement ses technologies de paiement à l'organisme Gnut 06. Une contribution au fonctionnement de HelloAsso, modifiable et facultative.</p>
                      
                      <label className="flex items-start">
                        <input type="checkbox" className="mr-2 mt-1" />
                        <span className="text-xs">
                          J'accepte les conditions d'utilisation de service de FI loi charte de confidentialité *
                        </span>
                      </label>
                    </div>

                    <div className="mt-6">
                      <h5 className="font-medium mb-3">Paiement sécurisé 🔒</h5>
                      <div className="flex space-x-2 mb-4">
                        <div className="w-10 h-6 bg-blue-600 rounded flex items-center justify-center text-white text-xs">VISA</div>
                        <div className="w-10 h-6 bg-red-600 rounded flex items-center justify-center text-white text-xs">MC</div>
                        <div className="w-10 h-6 bg-yellow-500 rounded flex items-center justify-center text-white text-xs">€</div>
                      </div>
                      <Button className="w-full bg-purple-600 hover:bg-purple-700 text-white py-3 rounded-lg font-medium">
                        Finaliser
                      </Button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default NousSoutenir;