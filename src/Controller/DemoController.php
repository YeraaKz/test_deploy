<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

class DemoController extends AbstractController
{
    #[Route('/demo', name: 'app_demo')]
    public function index(): JsonResponse
    {
        return $this->json([
            'message' => 'Almas kotakbas',
            'path' => 'src/Controller/DemoController.php',
        ]);
    }
}
