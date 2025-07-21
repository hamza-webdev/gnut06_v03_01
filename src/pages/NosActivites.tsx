import Header from '@/components/Header';
import Footer from '@/components/Footer';

const NosActivites = () => {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="pt-20">
        {/* Hero Section */}
        <section className="relative py-24 overflow-hidden">
          <div className="absolute inset-0 bg-gradient-radial from-primary/10 via-transparent to-transparent"></div>
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <h1 className="text-4xl lg:text-6xl font-bold text-gradient mb-8">
              Nos Activités
            </h1>
            <p className="text-xl text-muted-foreground max-w-3xl mx-auto">
              Découvrez toutes nos activités dédiées à l'inclusion et à l'innovation technologique
            </p>
          </div>
        </section>

        {/* Activities Content */}
        <section className="py-20">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center">
              <h2 className="text-2xl font-bold mb-8">Contenu en cours de développement</h2>
              <p className="text-muted-foreground">
                Cette page présentera prochainement toutes nos activités en détail.
              </p>
            </div>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
};

export default NosActivites;