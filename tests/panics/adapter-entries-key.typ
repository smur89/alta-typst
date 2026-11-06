// expect: entries() key must be "work", "volunteer", "focus-areas", "skills", "languages", "education", "certificates", "awards", "projects", "publications", "interests", or "references", got: "focusAreas"
#import "/lib.typ": adapter

#adapter.entries((:), "focusAreas")
