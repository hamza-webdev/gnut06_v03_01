import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Label } from '@/components/ui/label';
import { Checkbox } from '@/components/ui/checkbox';
import { RadioGroup, RadioGroupItem } from '@/components/ui/radio-group';
import { Mail, Phone, MapPin, Calendar } from 'lucide-react';

const NousContacter = () => {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="pt-20">
        {/* Hero Section */}
        <section className="relative py-24 overflow-hidden">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid lg:grid-cols-2 gap-12 items-start">
              <div className="space-y-8">
                <h1 className="text-4xl lg:text-6xl font-bold">
                  <span className="text-gradient">Nous Contacter</span>
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                  Pour toute question, n'hésitez pas à nous contacter via les informations 
                  ci-dessous
                </p>

                {/* Contact Information */}
                <div className="space-y-6">
                  <div className="flex items-center space-x-4">
                    <div className="inline-flex items-center justify-center w-12 h-12 bg-primary/10 rounded-full">
                      <Mail className="w-6 h-6 text-primary" />
                    </div>
                    <div>
                      <h3 className="font-medium">Email</h3>
                      <p className="text-muted-foreground">contact@gnut06.fr</p>
                    </div>
                  </div>

                  <div className="flex items-center space-x-4">
                    <div className="inline-flex items-center justify-center w-12 h-12 bg-primary/10 rounded-full">
                      <Phone className="w-6 h-6 text-primary" />
                    </div>
                    <div>
                      <h3 className="font-medium">Téléphone</h3>
                      <p className="text-muted-foreground">+33 6 66 21 56 87</p>
                    </div>
                  </div>

                  <div className="flex items-center space-x-4">
                    <div className="inline-flex items-center justify-center w-12 h-12 bg-primary/10 rounded-full">
                      <Calendar className="w-6 h-6 text-primary" />
                    </div>
                    <div>
                      <h3 className="font-medium">Visio</h3>
                      <p className="text-muted-foreground">Réservez votre créneau dès maintenant</p>
                    </div>
                  </div>

                  <div className="flex items-center space-x-4">
                    <div className="inline-flex items-center justify-center w-12 h-12 bg-primary/10 rounded-full">
                      <MapPin className="w-6 h-6 text-primary" />
                    </div>
                    <div>
                      <h3 className="font-medium">Bureau</h3>
                      <p className="text-muted-foreground">9 Rue du Pont-Vieux 06300 NICE FRANCE</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Map */}
              <div className="relative">
                <div className="bg-card border border-border rounded-2xl overflow-hidden">
                  <div className="h-64 bg-gradient-to-br from-primary/10 to-purple-600/10 flex items-center justify-center">
                    <div className="text-center">
                      <MapPin className="w-12 h-12 text-primary mx-auto mb-4" />
                      <h3 className="text-xl font-bold mb-2">9 Rue du Pont-Vieux</h3>
                      <p className="text-muted-foreground">06300 NICE, FRANCE</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Contact Form Section */}
        <section className="py-20 bg-card/50">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center mb-12">
              <h2 className="text-3xl lg:text-4xl font-bold mb-4">
                Besoin d'un projet ? Demandez un devis.
              </h2>
              <p className="text-muted-foreground">
                Vous pouvez utiliser le formulaire disponible sur notre site. 
                Nous répondons généralement dans les 24 heures.
              </p>
            </div>

            <Card className="bg-card border-border">
              <CardContent className="p-8">
                <form className="space-y-6">
                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="space-y-2">
                      <Label htmlFor="prenom">Prénom *</Label>
                      <Input id="prenom" placeholder="Prénom" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="nom">Nom *</Label>
                      <Input id="nom" placeholder="Nom" />
                    </div>
                  </div>

                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="space-y-2">
                      <Label htmlFor="email">Email *</Label>
                      <Input id="email" type="email" placeholder="Email" />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="telephone">Numéro de téléphone *</Label>
                      <Input id="telephone" type="tel" placeholder="Numéro de téléphone" />
                      <p className="text-sm text-red-500">Veuillez saisir une valeur valide.</p>
                    </div>
                  </div>

                  <div className="space-y-4">
                    <Label>Type de projet *</Label>
                    <RadioGroup defaultValue="site-web">
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="site-web" id="site-web" />
                        <Label htmlFor="site-web">Site web simple</Label>
                      </div>
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="app-mobile" id="app-mobile" />
                        <Label htmlFor="app-mobile">Application mobile</Label>
                      </div>
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="salle-3d" id="salle-3d" />
                        <Label htmlFor="salle-3d">Salle 3D immersive</Label>
                      </div>
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="grands-projets" id="grands-projets" />
                        <Label htmlFor="grands-projets">Grands projets</Label>
                      </div>
                    </RadioGroup>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="message">Message</Label>
                    <Textarea 
                      id="message" 
                      placeholder="Tapez votre message..." 
                      className="min-h-[120px]"
                    />
                  </div>

                  <div className="space-y-2">
                    <Label>Champs obligatoires *</Label>
                    <div className="flex items-center space-x-2">
                      <Checkbox id="conditions" />
                      <Label htmlFor="conditions" className="text-sm">
                        J'accepte les conditions
                      </Label>
                    </div>
                  </div>

                  <Button className="w-full btn-tech">
                    Soumettre
                  </Button>
                </form>
              </CardContent>
            </Card>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default NousContacter;