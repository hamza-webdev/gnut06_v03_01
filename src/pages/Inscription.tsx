import Header from '@/components/Header';
import Footer from '@/components/Footer';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Separator } from '@/components/ui/separator';
import { Eye, EyeOff, Mail, Lock } from 'lucide-react';
import { useState } from 'react';

const Inscription = () => {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="pt-20">
        <section className="py-20">
          <div className="max-w-md mx-auto px-4 sm:px-6 lg:px-8">
            <Card className="bg-card border-border shadow-xl">
              <CardContent className="p-8">
                <div className="text-center mb-8">
                  <h1 className="text-3xl font-bold text-gradient mb-2">Connexion</h1>
                  <p className="text-muted-foreground">
                    Connectez-vous à votre espace GNUT06
                  </p>
                </div>

                <form className="space-y-6">
                  <div className="space-y-2">
                    <Label htmlFor="email">Email</Label>
                    <div className="relative">
                      <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
                      <Input 
                        id="email" 
                        type="email" 
                        placeholder="votre@email.com"
                        className="pl-10"
                      />
                    </div>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="password">Mot de passe</Label>
                    <div className="relative">
                      <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4" />
                      <Input 
                        id="password" 
                        type={showPassword ? "text" : "password"}
                        placeholder="••••••••"
                        className="pl-10 pr-10"
                      />
                      <button
                        type="button"
                        onClick={() => setShowPassword(!showPassword)}
                        className="absolute right-3 top-1/2 transform -translate-y-1/2 text-muted-foreground"
                      >
                        {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  <div className="flex items-center justify-between">
                    <label className="flex items-center">
                      <input type="checkbox" className="mr-2" />
                      <span className="text-sm text-muted-foreground">Se souvenir de moi</span>
                    </label>
                    <a href="#" className="text-sm text-primary hover:underline">
                      Mot de passe oublié ?
                    </a>
                  </div>

                  <Button className="w-full btn-tech">
                    Se connecter
                  </Button>

                  <div className="relative">
                    <Separator />
                    <div className="absolute inset-0 flex items-center justify-center">
                      <span className="bg-card px-2 text-sm text-muted-foreground">ou</span>
                    </div>
                  </div>

                  <div className="text-center">
                    <p className="text-sm text-muted-foreground">
                      Pas encore de compte ?{' '}
                      <a href="#" className="text-primary hover:underline font-medium">
                        Créer un compte
                      </a>
                    </p>
                  </div>
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

export default Inscription;